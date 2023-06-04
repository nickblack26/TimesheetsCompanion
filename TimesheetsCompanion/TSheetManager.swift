//
//  TSheetManager.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/21/23.
//

import Foundation

struct ServerResponse: Codable {
	let results: ResultData
	let supplemental_data: SupplementalData?
}

struct ResultData: Codable {
	let current_totals: [String: ReportModel]?
	let timesheets: [String: TimesheetModel]?
	let jobcodes: [String: JobcodeModel]?
}

struct SupplementalData: Codable {
	let users: [String: UserModel]?
	//    let groups: [String: GroupModel]
	let timesheets: [String: TimesheetModel]?
	let jobcodes: [String: JobcodeModel]?
}

struct TimesheetUpload: Codable {
	var data: [TimesheetServerModel]
}

enum EndPoint: String {
	case authorize = "authorize"
	case timesheets = "timesheets"
	case jobcodes = "jobcodes"
	case reports = "reports/current_totals"
}

enum Method: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
}

@MainActor
class TSheetManager: ObservableObject {
	static var shared = TSheetManager()
	@Published var currentJob: JobcodeModel? {
		didSet {
			if (currentTimesheet != nil && currentJob!.id != currentTimesheet!.jobcode_id) {
				clockOut()
				print("clocked out")
				Task {
					print("creating timesheet with jobcode: \(currentJob!.id)")
					try await createTimesheet(jobcode_id: currentJob!.id)
				}
			}
		}
	}
	@Published var currentTimesheet: TimesheetModel?
	@Published var timesheets: [TimesheetModel] = [] {
		didSet {
			if !timesheets.isEmpty {
				updateArray()
			}
		}
	}
	@Published var jobcodes: [JobcodeModel] = []
	@Published var on_the_clock: Bool = false
	@Published var on_break: Bool = false
	@Published var duration: Int = 0
	private var currentTimesheetIndex: Int = -1
	private var timer: Timer = Timer()
	private var session = URLSession.shared
	
	init() {
		Task {
			let timesheetsResult = try await fetchTodaysTimesheets()
			self.jobcodes = timesheetsResult?.supplemental_data?.jobcodes?.map { $1 } ?? []
			self.timesheets = timesheetsResult?.results.timesheets?.map { $1 } ?? []
			self.timesheets.sort { return $0.date < $1.date }
		}
		
		Task(priority: .background) {
			let jobcodesResult = try await fetchAllJobcodes()
			self.jobcodes = jobcodesResult?.results.jobcodes?.map { $1 } ?? []
			if self.currentJob == nil && !self.jobcodes.isEmpty {
				self.currentJob = self.jobcodes[0]
			}
			self.jobcodes.sort { $0.name < $1.name }
		}
	}
	
	private func updateArray() {
		if timesheets.isEmpty { return }
		
		// find the index of the array that is on the clock
		if let index = self.timesheets.firstIndex(where: { timesheet in
			timesheet.on_the_clock == true
		}) {
			// set current index for easier saving in the future
			self.currentTimesheetIndex = index
			
			// set the current timesheet to the timesheet at the index specificied above
			self.currentTimesheet = self.timesheets[index]
			
			// calculate time difference between now and the start of the timesheet
			let date = Date.now
			self.duration = Int(date.timeIntervalSince(self.currentTimesheet!.start))
			
			// find the jobcode that the current timesheet is working on
			if let jobcode: JobcodeModel = self.jobcodes.first(where: { jobcode in
				jobcode.id == currentTimesheet!.jobcode_id
			}) {
				// set the currentJob to the jobcode found above
				self.currentJob = jobcode
				
				// if the jobcode is a break then set the on_break boolean to true
				if(currentJob?.type == "paid_break" || currentJob?.type == "unpaid_break") {
					self.on_the_clock = false
					self.on_break = true
				} else {
					self.on_the_clock = true
					self.on_break = false
				}
				
				startTimer()
			}
			
		} else {
			// if no timesheets are currently on the clock then do some house keeping
			if self.timesheets.isEmpty && !self.jobcodes.isEmpty {
				self.currentJob = self.jobcodes[0]
			} else {
				self.currentJob = self.jobcodes.first(where: { job in
					job.id == self.timesheets[0].jobcode_id
				})
			}
			self.currentTimesheetIndex = -1
			self.currentTimesheet = nil
			self.duration = 0
			self.on_the_clock = false
			self.on_break = false
			stopTimer()
		}
	}
	
	private func createURL(endpoint: EndPoint, queryItems: [URLQueryItem]?) -> URL? {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "rest.tsheets.com"
		components.path = "/api/v1/\(endpoint.rawValue)"
		components.queryItems = queryItems
		
		return components.url
	}
	
	private func makeRequest(endpoint: EndPoint, httpMethod: Method = .get, queryItems: [URLQueryItem] = [], httpBody: Data? = nil, body: Data? = nil) async throws -> ServerResponse? {
		let headers = [
			"Authorization": "Bearer S.21__2cd45655d46ff997486172c96f516a0accf7661a",
			"Content-Type": "application/json",
		]
		
		// create url from endpoint and query items
		// return nil if it can't be created
		guard let url = createURL(endpoint: endpoint, queryItems: queryItems) else { return nil }
		
		var request = URLRequest(url: url)
		request.allHTTPHeaderFields = headers
		request.httpMethod = httpMethod.rawValue
		request.httpBody = httpBody
		
		let decoder = JSONDecoder()
		
		do {
			let (data, _) = httpMethod == .get ? try await session.data(for: request) : try await session.upload(for: request, from: body!)
			print(String(data: data, encoding: .utf8)!)
			//
			//			let html = try Regex("<html><body onLoad=\"window\\.location\\.replace\\('(?:[^']|'')*'\\);\">&nbsp;</body></html>")
			//
			//			if let match = data.contains(html) {
			//				print("Key: \(match.1)")
			//			}
			
			return try decoder.decode(ServerResponse.self, from: data)
		} catch {
			print(String(describing: error))
		}
		
		return nil
	}
	
	private func startTimer() {
		self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in self.duration += 1 }
		self.timer.fire()
	}
	
	private func stopTimer() {
		self.duration = 0
		self.timer.invalidate()
	}
	
	func authorizationRequest(client_id: String, redirect_uri: String) async throws {
		let queryItems: [URLQueryItem] = [
			.init(name: "response_type", value: "code"),
			.init(name: "client_id", value: client_id),
			.init(name: "redirect_uri", value: redirect_uri),
			.init(name: "state", value: "tokenState")
		]
		
		
		try await makeRequest(endpoint: .authorize, queryItems: queryItems)
		//		guard let url = createURL(endpoint: .authorize, queryItems: queryItems) else { return }
		
		
	}
	
	func fetchTodaysTimesheets() async throws -> ServerResponse? {
		// create today's date in a pretty string format
		let date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-dd"
		let today = dateFormatter.string(from: date)
		
		// create query items to append to the end of the url
		let queryItems: [URLQueryItem] = [.init(name: "start_date", value: today), .init(name: "on_the_clock", value: "both")]
		
		return try await makeRequest(endpoint: .timesheets, queryItems: queryItems)
	}
	
	func fetchAllTimesheets() async throws -> ServerResponse? {
		// create a date 4 days from now in a pretty string format
		guard let date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return nil }
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-dd"
		let queryDate = dateFormatter.string(from: date)
		
		// create query items to append to the end of the url
		let queryItems: [URLQueryItem] = [.init(name: "start_date", value: queryDate), .init(name: "on_the_clock", value: "both")]
		
		return try await makeRequest(endpoint: .timesheets, queryItems: queryItems)
	}
	
	func createTimesheet(jobcode_id: Int, current: Bool = true, end: Date? = nil) async throws -> ServerResponse? {
		let timesheet = TimesheetModel(user_id: 3514010, jobcode_id: jobcode_id, end: end, type: "regular", on_the_clock: current, created_by_user_id: 3514010)
		
		if(current) {
			currentTimesheet = timesheet
			currentTimesheetIndex = 0
		}
		
		self.timesheets.insert(timesheet, at: 0)
		
		let serverModel: TimesheetServerModel = .init(model: timesheet)
		
		let timesheetFormat: TimesheetUpload = .init(data: [serverModel])
		
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		let timesheetData = try encoder.encode(timesheetFormat)
		
		return try await makeRequest(endpoint: .timesheets, httpMethod: .post, body: timesheetData)
	}
	
	func updateTimesheet(timesheet: TimesheetModel) async throws -> ServerResponse? {
		let serverModel: TimesheetServerModel = .init(model: timesheet, update: true)
		
		let timesheetFormat: TimesheetUpload = .init(data: [serverModel])
		
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		let timesheetData = try encoder.encode(timesheetFormat)
		
		return try await makeRequest(endpoint: .timesheets, httpMethod: .put, body: timesheetData)
	}
	
	func fetchAllJobcodes() async throws -> ServerResponse? {
		return try await makeRequest(endpoint: .jobcodes)
	}
	
	func fetchWorkersReport () async throws -> ServerResponse? {
		let parameters = ["data" : ["on_the_clock": "yes"]]
		
		let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
		
		return try await makeRequest(endpoint: .reports, body: postData!)
	}
	
	func clockOut() {
		self.currentTimesheet?.end = Date()
		self.currentTimesheet?.duration = self.duration
		self.currentTimesheet?.on_the_clock = false
		let timesheet = currentTimesheet!
		
		Task {
			try await updateTimesheet(timesheet: timesheet)
		}
		
		self.timesheets[self.currentTimesheetIndex] = timesheet
		self.currentTimesheet = nil
	}
	
	func clockIn() {
		if(self.on_break) {
			clockOut()
		}
		
		if (currentJob?.type == "paid_break" || currentJob?.type == "unpaid_break") {
			if let jobcode = self.jobcodes.first(where: { jobcode in
				jobcode.type != "unpaid_break" && jobcode.type != "paid_break"
			}) {
				self.currentJob = jobcode
				Task {
					try await self.createTimesheet(jobcode_id: jobcode.id)
				}
			}
		} else {
			Task {
				try await self.createTimesheet(jobcode_id: self.currentJob?.id ?? self.jobcodes[0].id)
			}
		}
	}
	
	func startBreak() {
		if self.on_the_clock {
			clockOut()
		}
		Task {
			
			try await self.createTimesheet(jobcode_id: 54395340)
		}
	}
}

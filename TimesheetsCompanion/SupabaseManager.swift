//
//  SupabaseManager.swift
//  TimesheetsCompanion
//
//  Created by Nick on 9/29/23.
//

import Foundation
import Observation
import Supabase
import GoTrue

@Observable
class SupabaseManager {
	// MARK: State variables
	var trackingHours = false
	var onBreak = false
	var showSignUp = false
	var timeEntries: [TimeEntryModel] = []
	var duration: TimeInterval = 0
	
	let client = SupabaseClient(supabaseURL: URL(string: "https://hgjbmyjxwrhseuvxjevs.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnamJteWp4d3Joc2V1dnhqZXZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzQ4NjY3NjIsImV4cCI6MTk5MDQ0Mjc2Mn0.VTflEJNAYefJ9TQDbmcIRcwdK_qrFNKTPevAPBf0cRg")
	var session: Session? {
		didSet {
			guard let session = session else { return }
			defaults.set(session.refreshToken, forKey: "refreshToken")
			defaults.set(session.accessToken, forKey: "accessToken")
		}
	}
	var currentClient: ClientModel? {
		didSet {
			guard let currentClient = currentClient else { return }
			guard let currentTimeEntry = currentTimeEntry else { return }
			Task {
				await updateTimeEntry(id: currentTimeEntry.id, .init(client: currentClient.id))
			}
		}
	}
	var currentProject: ProjectModel?
	var currentTimeEntry: TimeEntryModel? {
		didSet {
			guard let currentTimeEntry = currentTimeEntry else { return trackingHours = false }
			duration = Date.now.timeIntervalSince(currentTimeEntry.start_time)
			currentClient = currentTimeEntry.client
			currentProject = currentTimeEntry.project
			trackingHours = true
		}
	}
	var allClients: [ClientModel]?
	private let defaults = UserDefaults.standard
	private var timer: Timer?
	
	init() {
		Task(priority: .high) {
			let query = client.database
				.from("time_entries")
				.select(columns: "id, project: project(id, name), client: client(id, name), user: user(id, first_name, last_name), start_time, end_time, activity")
				.is(column: "end_time", value: "null")
				.single()
			
			do {
				currentTimeEntry = try await query.execute().value
				trackingHours = true
			} catch {
				currentTimeEntry = nil
				print("### Select Error: \(error)")
			}
		}
		
		Task(priority: .background) {
			let query = client.database
				.from("clients")
				.select()
			
			do {
				allClients = try await query.execute().value
			} catch {
				allClients = []
				print("### Select Error: \(error)")
			}
		}
	}
	
	func requestAuthorization() {
		Task {
			do {
				self.session = try await client.auth.session
			} catch {
				let refreshToken = defaults.object(forKey: "refreshToken") as? String
				let accessToken = defaults.object(forKey: "accessToken") as? String
				print(refreshToken ?? "Refresh")
				print(accessToken ?? "Access")
				if (refreshToken == nil || accessToken == nil) {
					//					showSignUp = true
					print("### Sign Up Error: \(error)")
					return
				}
				self.session = try await client.auth.setSession(accessToken: accessToken ?? "", refreshToken: refreshToken ?? "")
			}
		}
	}
	
	func signUp(email: String, password: String) {
		Task {
			do {
				try await client.auth.signUp(email: email, password: password)
				self.session = try await client.auth.session
				showSignUp = false
				print("### Session Info: \(String(describing: session))")
			} catch {
				print("### Sign Up Error: \(error)")
			}
		}
	}
	
	func signIn(email: String, password: String) {
		Task {
			do {
				try await client.auth.signIn(email: email, password: password)
				session = try await client.auth.session
				showSignUp = false
				print("### Session Info: \(String(describing: session))")
			} catch {
				print("### Sign Up Error: \(error)")
			}
		}
	}
	
	private func startTimer() {
		self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in self.duration += 1 }
		self.timer?.fire()
	}
	
	private func stopTimer() {
		self.duration = 0
		self.timer?.invalidate()
	}
	
	func clockIn() {
		guard let session = session else { return showSignUp = true }
		
		// create new mimimal time entry
		let timeEntry: TimeEntryInsertModel = .init(id: nil, user: session.user.id, start_time: Date(), end_time: nil, project: nil, client: nil, activity: nil)
		
		// Build query that returns the currently created timeEntry
		let query = client.database
			.from("time_entries")
			.insert(values: timeEntry, returning: .representation) // you will need to add this to return the added data
			.select(columns: "id, user(id, name), start_time")
			.single()
		
		Task {
			do {
				currentTimeEntry = try await query.execute().value
				startTimer()
			} catch {
				print(timeEntry)
				print("### Insert Error: \(error)")
			}
		}
	}
	
	func clockOut() {
		guard let currentTimeEntry = currentTimeEntry else { return }
		stopTimer()
		let timeEntry: TimeEntryInsertModel = .init(id: nil, user: nil, start_time: nil, end_time: Date(), project: nil, client: nil,  activity: nil)
		let query = client.database
			.from("time_entries")
			.update(values: timeEntry) // you will need to add this to return the added data
			.eq(column: "id", value: currentTimeEntry.id)
		
		Task {
			do {
				try await query.execute()
				trackingHours = false
				self.currentTimeEntry = nil
			} catch {
				print("### Insert Error: \(error)")
			}
		}
	}
	
	func updateTimeEntry(id: UUID, _ timeEntry: TimeEntryInsertModel) async -> TimeEntryModel? {
		let query = client.database
			.from("time_entries")
			.update(values: timeEntry, returning: .representation) // you will need to add this to return the added data
			.eq(column: "id", value: id)
			.select(columns: "*, user: user(id, name), project: project(id, name), project: client(id, name)")
			.single()
		
		print(timeEntry)
		
		do {
			let returnedValue: TimeEntryModel = try await query.execute().value
			print(returnedValue)
			return returnedValue
		} catch {
			print("### Insert Error: \(error)")
		}
		
		return nil
	}
	
	func deleteTimeEntry(id: UUID) async {
		let query = client.database
			.from("time_entries")
			.delete()
			.eq(column: "id", value: id)
		
		do {
			try await query.execute().value
		} catch {
			print("### Insert Error: \(error)")
		}
	}
}

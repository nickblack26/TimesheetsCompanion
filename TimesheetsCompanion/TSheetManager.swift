//
//  TSheetManager.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/21/23.
//

import Foundation

class TSheetManager: ObservableObject {
	@Published var on_the_clock: Bool = false
	@Published var on_break: Bool = false
	@Published var duration: Int = 0
	private var currentTimesheetIndex: Int = -1
	private var timer: Timer = Timer()
	private var session = URLSession.shared
	
	
	private func startTimer() {
		self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in self.duration += 1 }
		self.timer.fire()
	}
	
	private func stopTimer() {
		self.duration = 0
		self.timer.invalidate()
	}
	
	func clockOut() {
//		self.currentTimesheet?.end = Date()
//		self.currentTimesheet?.duration = self.duration
//		self.currentTimesheet?.on_the_clock = false
//		let timesheet = currentTimesheet!
		
		Task {
//			try await updateTimesheet(timesheet: timesheet)
		}
		
//		self.timesheets[self.currentTimesheetIndex] = timesheet
//		self.currentTimesheet = nil
	}
	
	func clockIn() {
//		if(self.on_break) {
//			clockOut()
//		}
//		
//		if (currentJob?.type == "paid_break" || currentJob?.type == "unpaid_break") {
//			if let jobcode = self.jobcodes.first(where: { jobcode in
//				jobcode.type != "unpaid_break" && jobcode.type != "paid_break"
//			}) {
//				self.currentJob = jobcode
//				Task {
////					try await self.createTimesheet(jobcode_id: jobcode.id)
//				}
//			}
//		} else {
//			Task {
////				try await self.createTimesheet(jobcode_id: self.currentJob?.id ?? self.jobcodes[0].id)
//			}
//		}
	}
	
	func startBreak() {
//		if self.on_the_clock {
//			clockOut()
//		}
//		Task {
////			try await self.createTimesheet(jobcode_id: 54395340)
//		}
	}
}

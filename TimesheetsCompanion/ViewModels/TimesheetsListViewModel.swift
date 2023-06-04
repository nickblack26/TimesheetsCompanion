//
//  TimesheetsListViewModel.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import Foundation

@MainActor
class TimesheetsListViewModel: ObservableObject {
    @Published var sectionedTimesheets: [Dictionary<Date, [TimesheetModel]>] = []
    @Published var timesheets: [TimesheetModel] = []
    @Published var jobcodes: [JobcodeModel] = []
    @Published var days: [Date] = []
    let manager = TSheetManager.shared
    
    init() {
        self.getDays()
        Task {
            let result = try await manager.fetchAllTimesheets()
            self.jobcodes = result?.supplemental_data?.jobcodes?.map { $1 } ?? []
            self.timesheets = result?.results.timesheets?.map { $1 } ?? []
            self.days.indices.forEach { index in
                for timesheet in timesheets {
//                    print("\(timesheet.start) -> \(days[index])")
                    if Calendar.current.isDate(timesheet.start, equalTo: days[index], toGranularity: .day) {
                        sectionedTimesheets.append([days[index]: [timesheet]])
                    }
                }
            }
        }
    }
    
    deinit {
        print("Deinitialized")
    }
    
    private func getDays() {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        for _ in 1...10 {
            self.days.append(date)
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
//        print(self.days)
    }
}

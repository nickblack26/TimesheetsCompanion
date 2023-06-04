//
//  AppNavigation.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/23/23.
//

import Foundation

enum Tab {
    case login
    case home
    case timesheets
    case working
    case jobcodes
    case timesheetEdit
}

class AppNavigation: ObservableObject {
    @Published var tab: Tab = .home
    @Published var timesheet: TimesheetModel = .init(id: 0, user_id: 0, jobcode_id: 0, start: Date.now.ISO8601Format(), end: Date.now.ISO8601Format(), duration: 0, date: Date.now.ISO8601Format(), type: "regular", on_the_clock: false)
    @Published var on_the_clock: Bool = false
    @Published var on_break: Bool = false
    private var path: [Tab] = []
    
    func navigate(tab: Tab, timesheet: TimesheetModel) {
        self.path.append(self.tab)
        self.timesheet = timesheet
        self.tab = tab
    }
    
    func navigate(tab: Tab) {
        self.path.append(self.tab)
        self.tab = tab
    }
    
    func goBack() {
        if let tab = path.last {            
            self.tab = tab
            self.path.removeLast()
        } else {
            self.tab = .home
        }
    }
}

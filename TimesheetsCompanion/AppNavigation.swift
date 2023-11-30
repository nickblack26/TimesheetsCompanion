//
//  AppNavigation.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/23/23.
//

import Foundation
import Observation

enum Tab {
    case login
    case home
    case timesheets
    case working
	case clients
	case timesheetDetail(timeEntry: TimeEntryModel)
}

@Observable
class AppNavigation: ObservableObject {
	var tab: Tab = .home
	private var path: [Tab] = []
    
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

let previewNavigationManager = AppNavigation()

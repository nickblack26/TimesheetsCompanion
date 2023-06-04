//
//  ContentView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/19/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigation: AppNavigation
    
    var body: some View {
        ZStack {
            switch navigation.tab {
				case .login: LoginView()
				case .home: HomeView()
				case .timesheets: TimesheetsListView()
				case .jobcodes: JobcodesListView()
				case .working: WorkingReportView()
				case .timesheetEdit: TimesheetDetail(timesheet: $navigation.timesheet)
            }
        }
    }
}

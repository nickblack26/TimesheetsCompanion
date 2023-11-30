//
//  ContentView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/19/23.
//

import SwiftUI

struct ContentView: View {
	@Environment(AppNavigation.self) private var navigation
	@Environment(SupabaseManager.self) private var supabase
	
	var body: some View {
		ZStack {
			switch navigation.tab {
				case .login: LoginView()
				case .home: HomeView().transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
				case .timesheets: TimeEntriesListView()
				case .clients: ClientsListView().transition(.push(from: .top))
				case .working: WorkingReportView()
				case .timesheetDetail(let timeEntry): TimesheetDetail(timeEntry: timeEntry)
			}
		}
		.onChange(of: supabase.trackingHours) {
			if supabase.trackingHours {
				Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
					supabase.duration += 1
				}
			}
		}
	}
}

#Preview {
	ContentView()
		.environment(previewSupabaseManager)
		.environment(previewNavigationManager)
		.previewLayout(.sizeThatFits)
	
}


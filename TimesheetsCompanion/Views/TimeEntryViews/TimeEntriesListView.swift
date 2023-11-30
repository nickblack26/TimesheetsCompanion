//
//  TimesheetsListView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import SwiftUI

struct TimeEntriesListView: View {
	@Environment(AppNavigation.self) private var navigation
	@Environment(SupabaseManager.self) private var supabase
	@State private var timeEntries: [TimeEntryModel] = []
	var tabDestination: Tab = .home
	
	var body: some View {
		Grid(alignment: .topLeading, verticalSpacing: 10) {
			HStack {
				Button {
					navigation.navigate(tab: tabDestination)
				} label: {
					Image(systemName: "chevron.left")
				}
				.buttonStyle(.plain)
				
				Text("Time Entries")
					.fontWeight(.bold)
			}
			
			Divider()
			
			GridRow(alignment: .top) {
				VStack(alignment: .leading, spacing: 5) {
					if(supabase.timeEntries.isEmpty) {
						ProgressView()
							.frame(maxWidth: .infinity, alignment: .center)
					} else {
						ForEach(supabase.timeEntries) { entry in
							Button {
								navigation.navigate(tab: .timesheetDetail(timeEntry: entry))
							} label: {
								TimeEntryItem(client: entry.client?.name, startDate: entry.start_time, endDate: entry.end_time, duration: 0, type: "", activity: entry.activity)
							}
							.buttonStyle(.plain)
						}
					}
				}
			}
		}
		.padding(10)
		.background {
			RoundedRectangle(cornerRadius: 10, style: .continuous)
				.fill(.thinMaterial)
				.shadow(radius: 1)
		}
		.task {
			let query = supabase.client.database
				.from("time_entries")
				.select(columns: "id, project: project(id, name), client: client(id, name), user: user(id, first_name, last_name), start_time, end_time, activity")
				.order(column: "start_time", ascending: false)
				.limit(count: 10)
			
			do {
				supabase.timeEntries = try await query.execute().value
			} catch {
				timeEntries = []
				print("### Select Error: \(error)")
			}
		}
	}
}

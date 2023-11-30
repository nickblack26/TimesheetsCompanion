import SwiftUI

struct HomeView: View {
	// MARK: Environment Variables
	@Environment(AppNavigation.self) private var navigation
	@Environment(SupabaseManager.self) private var supabase
	
	// MARK: State Variables
	@State private var timeEntries: [TimeEntryModel] = []
	@State private var timeFormatter = ElapsedTimeFormatter()
	@State private var activity: String = ""
	@FocusState private var focused: Bool
	
	var body: some View {
		Grid(horizontalSpacing: 10, verticalSpacing: 10) {
			GridRow(alignment: .top) {
				VStack(spacing: 10) {
					Button {
						withAnimation {
							navigation.navigate(tab: .clients)
						}
					} label: {
						ControlView(icon: "building.2.crop.circle.fill", title: supabase.currentClient == nil ? "Clients" : "Client", subTitle: supabase.currentClient?.name)
					}
					.buttonStyle(.plain)
					
					Button {
						navigation.navigate(tab: .working)
					} label: {
						ControlView(icon: "doc.circle.fill", title: "Projects", subTitle: supabase.currentTimeEntry?.project?.name)
					}
					.buttonStyle(.plain)
					
					Button {
						navigation.navigate(tab: .timesheets)
					} label: {
						ControlView(icon: "calendar.circle.fill", title: "Time Entries", subTitle: nil)
					}
					.buttonStyle(.plain)
				}
				.padding(10)
				.background {
					RoundedRectangle(cornerRadius: 10, style: .continuous)
						.fill(.thinMaterial)
						.shadow(radius: 1)
				}
				
				Grid(verticalSpacing: 10) {
					GridRow {
						Button {
							if supabase.trackingHours {
								supabase.clockOut()
							} else {
								supabase.clockIn()
							}
						} label: {
							SubControlView(icon: supabase.trackingHours ? "pause.circle.fill" : "play.circle.fill", foregroundColor: supabase.trackingHours ? .red : nil, title: supabase.trackingHours ? "Current" : "Clock in", subtitle: supabase.trackingHours ? supabase.duration : nil)
						}
						.buttonStyle(.plain)
					}
					
					GridRow {
						Button {

						} label: {
							SubControlView(icon: "person.crop.circle.badge.clock.fill", foregroundColor: .orange, title: supabase.trackingHours ? "On Break" : "Take Break", subtitle: supabase.trackingHours ? supabase.duration : nil)
						}
						.buttonStyle(.plain)
					}
				}
				.gridCellUnsizedAxes(.vertical)
				
			}
			
			if let currentTimeEntry = supabase.currentTimeEntry {
				GridRow(alignment: .top) {
					Grid(alignment: .topLeading, verticalSpacing: 10) {
						Text("Activity")
							.fontWeight(.bold)
						
						Divider()
						
						Form {
							TextField("Activity", text: $activity, prompt: Text("Hello"), axis: .vertical)
								.textFieldStyle(.plain)
								.labelsHidden()
								.defaultFocus($focused, false)
								.onKeyPress(.return, action: {
									focused = false
									if(currentTimeEntry.activity != activity) {
										Task {
											await supabase.updateTimeEntry(
												id: currentTimeEntry.id,
												.init(id: nil, user: nil, start_time: nil, end_time: nil, project: nil, client: nil, activity: activity))
										}
									}
									return .handled
								})
								.focused($focused)
						}
					}
				}
				.padding(.vertical, 5)
				.padding(.horizontal, 10)
				.background {
					RoundedRectangle(cornerRadius: 10, style: .continuous)
						.fill(.thinMaterial)
						.shadow(radius: 1)
				}
				.gridCellColumns(2)
			}
			
			if !timeEntries.isEmpty {
				GridRow(alignment: .top) {
					Grid(alignment: .topLeading, verticalSpacing: 10) {
						Text("Time Entries")
							.fontWeight(.bold)
						
						VStack(spacing: 5) {
							ForEach(timeEntries) { entry in
								Button {
									navigation.navigate(tab: .timesheetDetail(timeEntry: entry))
								} label: {
									TimeEntryItem(client: entry.client?.name, startDate: entry.start_time, endDate: entry.end_time, duration: 0, type: "", activity: entry.activity)
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
					.gridCellColumns(2)
				}
			}
		}
		.onAppear {
			supabase.requestAuthorization()
		}
		.task {
			let localISOFormatter = ISO8601DateFormatter()
			localISOFormatter.timeZone = TimeZone.current
			let date = Date() // current date or replace with a specific date
			let calendar = Calendar.current
			let startTime = calendar.startOfDay(for: date)
			let endTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? Date()
			
			let query = supabase.client.database
				.from("time_entries")
				.select()
				.lt(column: "end_date",  value: endTime.ISO8601Format())
				.gt(column: "start_date",  value: startTime.ISO8601Format())
			
			print(startTime.formatted(.iso8601.dateTimeSeparator(.space).timeZoneSeparator(.omitted)))
			print(localISOFormatter.string(from: date))
			
			
			do {
				timeEntries = try await query.execute().value
			} catch {
				timeEntries = []
				print("### Select Error: \(error)")
			}
		}
		.padding(10)
	}
}


#Preview {
	HomeView()
		.environment(previewSupabaseManager)
		.environment(previewNavigationManager)
		.previewLayout(.sizeThatFits)
	
}

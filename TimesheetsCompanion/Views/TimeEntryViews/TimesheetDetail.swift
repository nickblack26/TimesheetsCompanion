//
//  TimesheetDetail.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import SwiftUI

struct TimesheetDetail: View {
	// MARK: Environment Variables
	@Environment(SupabaseManager.self) private var supabase
	@Environment(AppNavigation.self) private var navigation
	
	// MARK: State Variables
	@State private var currentlyWorking: Bool = false
	@State var isExpanded = false
	@State private var startTime: Date = Date()
	@State private var endTime: Date = Date()
	@State private var activity: String = ""
	@FocusState private var focused: Bool
	
	var timeEntry: TimeEntryModel
	
	init(timeEntry: TimeEntryModel) {
		self.timeEntry = timeEntry
		self._currentlyWorking = State(initialValue: timeEntry.end_time == nil ? true : false)
	}
	
	var body: some View {
		ScrollView {
			Grid(horizontalSpacing: 10, verticalSpacing: 10) {
				GridRow(alignment: .top) {
					Button {
						navigation.goBack()
					} label: {
						HStack {
							Image(systemName: "chevron.left")
							Text("Clients")
								.fontWeight(.bold)
						}
					}
					.buttonStyle(.plain)
					.frame(maxWidth: .infinity, alignment: .leading)
					
					Button(role: .destructive) {
						Task {
							await supabase.deleteTimeEntry(id: timeEntry.id)
						}
						navigation.goBack()
					} label: {
						HStack {
							Text("Delete Activity")
							Image(systemName: "trash.fill")
						}
					}
					.buttonStyle(.plain)
					.foregroundStyle(.red)
					.frame(maxWidth: .infinity, alignment: .trailing)
				}
				.gridCellUnsizedAxes(.vertical)
				
				Divider()
				
				GridRow(alignment: .top) {
					Card {
						VStack(spacing: 10) {
							DisclosureGroup(isExpanded: $isExpanded) {
								DatePicker("Start Time", selection: $startTime)
									.labelsHidden()
							} label: {
								Button {
									isExpanded.toggle()
								} label: {
									ControlView(icon: "calendar.circle.fill", title: "Start Time", subTitle: timeEntry.start_time.formatted(date: .abbreviated, time: .shortened), lineLimit: 2)
								}
								.buttonStyle(.plain)
							}
							
							DisclosureGroup {
								DatePicker("End Time", selection: $endTime)
									.labelsHidden()
							} label: {
								ControlView(icon: "calendar.circle.fill", title: "End Time", subTitle: currentlyWorking ? "Current" : Date().formatted(date: .abbreviated, time: .shortened), lineLimit: 2)
							}
							.buttonStyle(.plain)
							.tint(.clear)
							
						}
					}
					
					Grid(verticalSpacing: 10) {
						GridRow {
							Button {
								navigation.navigate(tab: .clients)
							} label: {
								HStack {
									Image(systemName: "building.2.crop.circle.fill")
										.font(.largeTitle)
										.foregroundColor(.green)
									
									VStack(alignment: .leading) {
										Text("Client")
											.font(.callout)
											.foregroundColor(.primary)
											.fontWeight(.semibold)
										
										if let client_id = timeEntry.client {
											Text(client_id.name)
												.font(.caption2)
												.foregroundColor(.primary)
												.opacity(0.7)
										}
									}
								}
								.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
								.padding(10)
								.background {
									RoundedRectangle(cornerRadius: 10, style: .continuous)
										.fill(.thinMaterial)
										.shadow(radius: 1)
								}
							}
							.buttonStyle(.plain)
						}
						
						GridRow {
							Button {
								
							} label: {
								HStack {
									Image(systemName: "building.2.crop.circle.fill")
										.font(.largeTitle)
										.foregroundColor(.blue)
									
									VStack(alignment: .leading) {
										Text("Project")
											.font(.callout)
											.foregroundColor(.primary)
											.fontWeight(.semibold)
										
										if let client_id = timeEntry.client {
											Text(client_id.name)
												.font(.caption2)
												.foregroundColor(.primary)
												.opacity(0.7)
										}
									}
								}
								.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
								.padding(10)
								.background {
									RoundedRectangle(cornerRadius: 10, style: .continuous)
										.fill(.thinMaterial)
										.shadow(radius: 1)
								}
							}
							.buttonStyle(.plain)
						}
					}
					.gridCellUnsizedAxes(.vertical)
				}
				
				Card(title: "Activity") {
					TextField("Activity", text: $activity, prompt: Text("Enter activity name..."), axis: .vertical)
						.lineLimit(3, reservesSpace: true)
						.textFieldStyle(.plain)
						.labelsHidden()
						.defaultFocus($focused, false)
						.onKeyPress(.return, action: {
							focused = false
							Task {
								await supabase.updateTimeEntry(
									id: timeEntry.id,
									.init(id: nil, user: nil, start_time: nil, end_time: nil, project: nil, client: nil, activity: activity))
							}
							return .handled
						})
						.focused($focused)
				}
			}
//			.padding(10)
//			.background {
//				RoundedRectangle(cornerRadius: 10, style: .continuous)
//					.fill(.thinMaterial)
//					.shadow(radius: 1)
//			}
		}
		.scrollIndicators(.hidden)
		.onDisappear(perform: {
			Task {
				await supabase.updateTimeEntry(id: timeEntry.id, .init(id: nil, user: nil, start_time: timeEntry.start_time, end_time: timeEntry.end_time, project: timeEntry.project?.id, client: timeEntry.client?.id, activity: activity))
			}
		})
		.toolbar {
			ToolbarItem(placement: .navigation) {
				HStack {
					Image(systemName: "chevron.left")
					Text("Clients")
						.fontWeight(.bold)
				}
			}
			
			ToolbarItem(placement: .destructiveAction) {
				Label("Delete Activity", systemImage: "trash.fill")
			}
		}
	}
}

#Preview {
	TimesheetDetail(timeEntry: .init(id: UUID(), start_time: Date(), user: .init(id: UUID(), first_name: "Nick", last_name: "Black", image_url: "123.jpg", username: "nickblack26", stripe_id: "sk_1234"), end_time: nil))
		.environment(previewSupabaseManager)
		.environment(previewNavigationManager)
		.previewLayout(.sizeThatFits)
}

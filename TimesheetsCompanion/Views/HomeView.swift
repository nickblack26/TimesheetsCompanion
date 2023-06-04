//
//  ControlCentre.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/20/23.
//

import SwiftUI

struct HomeView: View {
	//    @StateObject var vm = HomeViewModel()
	@EnvironmentObject var navigation: AppNavigation
	@EnvironmentObject var manager: TSheetManager
	
	private func convertDateFormatter(date: Date) -> String {
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateFormat = "h:mma"///this is what you want to convert format
		dateFormatter.amSymbol = "am"
		dateFormatter.pmSymbol = "pm"
		let timeStamp = dateFormatter.string(from: date)
		
		return timeStamp
	}
	
	private func getDiffTime(seconds: Int) -> String {
		let hours = seconds / 3600
		let minutes = (seconds % 3600) / 60
		let seconds = seconds % 60
		return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
	}
	
	var body: some View {
		Grid(horizontalSpacing: 10, verticalSpacing: 10) {
			GridRow(alignment: .top) {
				VStack(spacing: 10) {
					Button {
						navigation.navigate(tab: .jobcodes)
					} label: {
						ControlView(icon: "clock.circle.fill", title: "Time Clock", subTitle: manager.currentJob?.name)
					}
					.buttonStyle(.plain)
					
					Button {
						navigation.navigate(tab: .working)
					} label: {
						ControlView(icon: "person.circle.fill", title: "Who's Working", subTitle: nil)
					}
					.buttonStyle(.plain)
					
					Button {
						navigation.navigate(tab: .timesheets)
					} label: {
						ControlView(icon: "list.bullet.circle.fill", title: "Time Entries", subTitle: nil)
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
							if manager.on_the_clock {
								Task {
									await manager.clockOut()
								}
							} else {
								manager.clockIn()
							}
						} label: {
							SubControlView(icon: manager.on_the_clock ? "pause.circle.fill" : "play.circle.fill", foregroundColor: manager.on_the_clock ? .red : nil, title: manager.on_the_clock ? "Current" : "Clock in", subtitle: manager.on_the_clock ? getDiffTime(seconds: manager.duration) : nil)
						}
						.buttonStyle(.plain)
					}
					
					GridRow {
						Button {
							if manager.on_break {
								Task {
									await manager.clockOut()
									
								}
							} else {
								manager.startBreak()
							}
						} label: {
							SubControlView(icon: "person.crop.circle.badge.clock.fill", foregroundColor: .orange, title: manager.on_break ? "On Break" : "Take Break", subtitle: manager.on_break ? getDiffTime(seconds: manager.duration) : nil)
						}
						.buttonStyle(.plain)
					}
				}
				.gridCellUnsizedAxes(.vertical)
				
			}
			
			if !$manager.timesheets.isEmpty {
				GridRow(alignment: .top) {
					Grid(alignment: .topLeading, verticalSpacing: 10) {
						Text("Time Entries")
							.fontWeight(.bold)
						
						VStack(spacing: 5) {
							ForEach($manager.timesheets) { $timesheet in
								if let jobcode = manager.jobcodes.first(where: {$0.id == timesheet.jobcode_id }) {
									Button {
										navigation.navigate(tab: .timesheetEdit, timesheet: timesheet)
									} label: {
										TimeSheetItem(client: jobcode.name, startDate: timesheet.start, endDate: timesheet.end, duration: timesheet.duration, type: jobcode.type)
									}
									.buttonStyle(.plain)
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
	}
}

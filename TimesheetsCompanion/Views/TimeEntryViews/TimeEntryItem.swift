//
//  TimeSheetItem.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/20/23.
//

import SwiftUI

struct TimeEntryItem: View {
	@State private var hovering: Bool = false
	@State private var timeFormatter = ElapsedTimeFormatter()
	@Environment(SupabaseManager.self) private var supabase
	let client: String?
	let startDate: Date
	let endDate: Date?
	let duration: Int
	let type: String
	let activity: String?
	
	private func secondsToFormattedTime(seconds: Int) -> String {
		// returns a empty string if seconds are less than or equal to 0
		if(seconds <= 0) { return "" }
		let hours = seconds / 3600
		let minutes = (seconds % 3600) / 60
		
		
		if(hours < 1) {
			return "\(String(format: "%02d", minutes))m"
		}
		
		if(hours < 10) {
			return "\(String(format: "%d", hours))h \(String(format: "%02d", minutes))m"
		}
		
		return "\(String(format: "%02d", hours))h \(String(format: "%02d", minutes))m"
	}
	
	private func convertDateFormatter(date: Date) -> String {
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateFormat = "h:mma"///this is what you want to convert format
		dateFormatter.amSymbol = "am"
		dateFormatter.pmSymbol = "pm"
		//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
		let timeStamp = dateFormatter.string(from: date)
		
		return timeStamp
	}
	
	var body: some View {
		HStack {
			if endDate == nil {
				Image(systemName: "clock.circle.fill")
					.font(.largeTitle)
					.foregroundColor(.green)
			} else {
				Image(systemName: "clock.circle.fill")
					.font(.largeTitle)
					.foregroundColor(.gray)
			}
			
			VStack(alignment: .leading, content: {
				if let endDate {
						HStack {
							Text(NSNumber(value: TimeInterval(endDate.timeIntervalSince(startDate))), formatter: timeFormatter)
						Text("(\(startDate.formatted(date: .omitted, time: .shortened)) - \(endDate.formatted(date: .omitted, time: .shortened)))")
							.font(.caption)
							.fontWeight(.medium)
						}
					} else {
						HStack {
							Text(NSNumber(value: TimeInterval(supabase.duration)), formatter: timeFormatter)
							Text("(\(startDate.formatted(date: .omitted, time: .shortened)) - Current)")
								.font(.caption)
							.fontWeight(.medium)
						}
				}
				Text(activity ?? "Enter activity name...")
					.font(.callout)
					.foregroundStyle(.secondary)
			})
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.onHover { hovering = $0 }
		.overlay(alignment: .trailing) {
			if hovering {
				Image(systemName: "chevron.right")
					.shadow(radius: 10, x: -10)
			}
		}
	}
}

#Preview {
	TimeEntryItem(client: "Evan's Meat Market", startDate: Date(), endDate: Date().addingTimeInterval(TimeInterval(120)), duration: 12, type: "Stuff", activity: nil)
		.environment(previewSupabaseManager)
}

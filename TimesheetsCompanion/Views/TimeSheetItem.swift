//
//  TimeSheetItem.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/20/23.
//

import SwiftUI

struct TimeSheetItem: View {
    @State private var hovering: Bool = false
    let client: String
    let startDate: Date
    let endDate: Date?
    let duration: Int
    let type: String
    
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
        ZStack(alignment: .trailing) {
            HStack {
                if type == "paid_break" || type == "unpaid_break" {
                    Image(systemName: "clock.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                } else {
                    Image(systemName: "building.2.crop.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                }
                
                Text(client)
                
                Spacer()
                
                Text(duration > 0 ? secondsToFormattedTime(seconds: duration) : "Current")
            }
            
            
            
            if hovering {
                Image(systemName: "chevron.right")
                    
            }
        }
        .onHover { hover in
            self.hovering = hover
        }
    }
}

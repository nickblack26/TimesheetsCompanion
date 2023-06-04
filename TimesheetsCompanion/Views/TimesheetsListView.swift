//
//  TimesheetsListView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import SwiftUI

struct TimesheetsListView: View {
    @StateObject private var vm = TimesheetsListViewModel()
    @EnvironmentObject var navigation: AppNavigation
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
                    ForEach(vm.sectionedTimesheets, id: \.self) { key in
                        Text(key.keys.description)
//                        print(String(data: section, encoding: .utf8)!).
                    }
//                    ForEach($vm.sectionedTimesheets, id: \.self) { key in
//                        Section(key.formatted(date: .complete, time: .omitted)) {
//                            ForEach(vm.sectionedTimesheets[key]) { timesheet in
//                                    if let jobcode = vm.jobcodes.first(where: {$0.id == timesheet.jobcode_id }) {
//                                        Button {
//                                            navigation.navigate(tab: .timesheetEdit)
//                                            // currentTimesheet = $timesheet
//                                        } label: {
//                                            TimeSheetItem(client: jobcode.name, startDate: timesheet.start, endDate: timesheet.end, duration: timesheet.duration, type: jobcode.type)
//                                        }
//                                        .buttonStyle(.plain)
//                                    }
//                            }
//                        }
//                    }
                }
            }
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.thinMaterial)
                .shadow(radius: 1)
        }
    }
}

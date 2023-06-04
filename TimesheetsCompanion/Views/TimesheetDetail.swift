//
//  TimesheetDetail.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import SwiftUI

struct TimesheetDetail: View {
    @State private var currentlyWorking: Bool = false
    @Binding var timesheet: TimesheetModel
    @StateObject private var vm = JobcodesListViewModel()
    @EnvironmentObject var navigation: AppNavigation
    
    init(timesheet: Binding<TimesheetModel>) {
        self._timesheet = timesheet
        print(self.timesheet)
        self._currentlyWorking = State(initialValue: self.timesheet.end == nil ? true : false)
    }
    
    var body: some View {
        Grid(alignment: .topLeading, verticalSpacing: 10) {
            HStack {
                Button {
                    navigation.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.plain)
                
                Text("Clients")
                    .fontWeight(.bold)
            }
            
            
            GridRow(alignment: .top) {
                Form {
                    TextField("Name", text: $timesheet.type)
                        .textFieldStyle(.roundedBorder)
                    Toggle("Currently Working", isOn: $currentlyWorking)
                    DatePicker("Start", selection: $timesheet.start)
                        .pickerStyle(.segmented)
                    if !currentlyWorking {
                        DatePicker("End", selection: $timesheet.end.toNonOptional())
                            .pickerStyle(.inline)
                    }
                    
                    Picker("Client", selection: $timesheet.jobcode_id) {
                        ForEach(vm.jobcodes) { jobcode in
                            Text(jobcode.name)
                                .tag(jobcode.id)
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
    }
}


extension Binding where Value == Date? {
    func toNonOptional() -> Binding<Date> {
        return Binding<Date>(
            get: {
                return self.wrappedValue ?? Date()
            },
            set: {
                self.wrappedValue = $0
            }
        )
    }
}

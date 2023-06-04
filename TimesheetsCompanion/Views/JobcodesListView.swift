//
//  ClientsListView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import SwiftUI

struct JobcodesListView: View {
    @StateObject private var vm = JobcodesListViewModel()
    @EnvironmentObject var navigation: AppNavigation
	@EnvironmentObject var manager: TSheetManager
    var tabDestination: Tab?
    @State private var searchBar: String = ""
    
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
            
            Divider()
            
            GridRow(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(manager.jobcodes) {jobcode in
                        Button {
							manager.currentJob = jobcode
//							vm.setJobcode(jobcode: jobcode)
                        } label: {
							JobcodeItem(jobcode: jobcode, currentJob: manager.currentJob!)
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.plain)
                    }
                }
            }
            .searchable(text: $searchBar)
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.thinMaterial)
                .shadow(radius: 1)
        }
    }
}

//
//  WorkingReportView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import SwiftUI

struct WorkingReportView: View {
	@Environment(AppNavigation.self) private var navigation
    var tabDestination: Tab = .home
    
    var body: some View {
        Grid(alignment: .topLeading, verticalSpacing: 10) {
            HStack {
                Button {
                    navigation.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.plain)
                
                Text("Who's Working")
                    .fontWeight(.bold)
            }
            
            Divider()
            
            GridRow(alignment: .top) {
                VStack(spacing: 5) {
//                    ForEach(vm.currentWorkers) { worker in
//                        if let user = vm.users.first(where: {$0.id == worker.user_id }) {
//                            Text(user.display_name)
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
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

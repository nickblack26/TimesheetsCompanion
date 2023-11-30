//
//  JobcodeDetail.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/23/23.
//

import SwiftUI

struct ClientListItem: View {
    @State private var hovering: Bool = false
    var client: ClientModel
	var currentClient: ClientModel?
    
    var body: some View {
		let isCurrentClient = (currentClient != nil) && currentClient?.id == client.id
       
		ZStack(alignment: .trailing) {
            if hovering {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(.primary.opacity(0.05))
                    .frame(maxWidth: .infinity)
            }
			
            HStack {
                Image(systemName: "building.2.crop.circle.fill")
                    .font(.largeTitle)
					.foregroundColor(isCurrentClient ? .green : .secondary)
                
				Text(client.name)
                
                Spacer()
            }
			.padding(.horizontal, 5)
			.padding(.vertical, 2.5)
        }
        .onHover { hover in
            self.hovering = hover
        }
    }
}

#Preview {
	ClientListItem(client: .init(id: UUID(), name: "Test"), currentClient: .init(id: UUID(), name: "Test"))
}

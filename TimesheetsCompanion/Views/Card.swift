//
//  TitleCard.swift
//  TimesheetsCompanion
//
//  Created by Nick on 10/2/23.
//

import SwiftUI

struct Card<C: View>: View {
	let title: String?
	let subtitle: String?
	let content: C
	
	init(title: String? = nil, subtitle: String? = nil, _ content: () -> (C)) {
		self.title = title
		self.subtitle = subtitle
		self.content = content()
	}
	
    var body: some View {
		Grid(alignment: .topLeading, horizontalSpacing: 10, verticalSpacing: 10) {
			if let title {
				VStack(alignment: .leading, content: {
					Text(title)
						.fontWeight(.semibold)
					
					if let subtitle {
						Text(subtitle)
							.font(.caption)
							.foregroundStyle(.secondary)
					}
				})
				
				Divider()
			}
			
			content
		}
		.padding(10)
		.background {
			RoundedRectangle(cornerRadius: 10, style: .continuous)
				.fill(.thinMaterial)
				.shadow(radius: 1)
		}
    }
}

#Preview {
	Card(title: "Activity", subtitle: "stuff") {
		Text("Stuff")
	}
}

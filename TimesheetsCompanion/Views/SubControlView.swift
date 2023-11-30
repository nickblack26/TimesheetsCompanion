//
//  SubControlView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/20/23.
//

import SwiftUI

struct SubControlView: View {
    let icon: String
    let foregroundColor: Color?
    let title: String
    let subtitle: TimeInterval?
	@State private var timeFormatter = ElapsedTimeFormatter()

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(foregroundColor ?? .green)
				.contentTransition(.symbolEffect(.replace.downUp.wholeSymbol))
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.callout)
                    .foregroundColor(.primary)
				if let subtitle {
					Text(NSNumber(value: subtitle), formatter: timeFormatter)
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
}

struct SubControlView_Previews: PreviewProvider {
    static var previews: some View {
        SubControlView(icon: "pause", foregroundColor: nil, title: "Pause", subtitle: nil)
    }
}

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
    let subtitle: String?
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(foregroundColor ?? .green)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.callout)
                    .foregroundColor(.primary)
                if subtitle != nil {
                    Text(subtitle!)
                        .font(.caption2)
                        .foregroundColor(.primary)
                        .opacity(0.7)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
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

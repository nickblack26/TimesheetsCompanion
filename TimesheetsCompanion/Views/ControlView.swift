//
//  ControlView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/20/23.
//

import SwiftUI

struct ControlView: View {
    @State private var hovering: Bool = false
    let icon: String
    let title: String
    let subTitle: String?
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.callout)
                        .foregroundColor(.primary)
                    
                    if subTitle != nil {
                        Text(subTitle!)
                            .font(.caption2)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                            .opacity(0.7)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if hovering {
                Image(systemName: "chevron.right")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onHover { hover in
            self.hovering = hover
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(icon: "wifi", title: "Wifi", subTitle: "Stuff")
    }
}

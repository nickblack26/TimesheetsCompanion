//
//  JobcodeDetail.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/23/23.
//

import SwiftUI

struct JobcodeItem: View {
    @State private var hovering: Bool = false
    var jobcode: JobcodeModel
	var currentJob: JobcodeModel
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if hovering {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(.primary.opacity(0.05))
                    .frame(maxWidth: .infinity)
                    
            }
			if currentJob.id == jobcode.id {
				RoundedRectangle(cornerRadius: 5, style: .continuous)
					.fill(.green)
					.frame(maxWidth: .infinity)
			}
            HStack {
                Image(systemName: "building.2.crop.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                
				Text(jobcode.name)
                
                Spacer()
            }
        }
        .onHover { hover in
            self.hovering = hover
        }
    }
}

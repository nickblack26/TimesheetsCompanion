//
//  TimesheetsCompanionApp.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/19/23.
//
//
import SwiftUI

@main
struct TimesheetsCompanionApp: App {
    var screenSize: CGSize = {
        guard let size = NSScreen.main?.visibleFrame.size else {
            return .zero
        }
        
        return size
    }()
    @StateObject var navigation = AppNavigation()
	@StateObject var manager = TSheetManager()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .frame(minWidth: screenSize.width / 9, maxWidth: screenSize.width / 6)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 1)
                }
                .environmentObject(navigation)
				.environmentObject(manager)
        } label: {
            HStack {
                Image(systemName: "clock")
                if navigation.on_break {
                    Text("•")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                }
            }
        }
        .menuBarExtraStyle(.window)
        
    }
}

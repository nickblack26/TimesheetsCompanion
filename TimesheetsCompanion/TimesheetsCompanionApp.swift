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
	
	private func getDiffTime(seconds: Int) -> String {
		let hours = seconds / 3600
		let minutes = (seconds % 3600) / 60
		let seconds = seconds % 60
		return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
	}
	
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
				if manager.on_the_clock {
					Text(getDiffTime(seconds: manager.duration))
						.font(.callout)
						.tint(.orange)
				}
				Image(systemName: "clock")
				if manager.on_break {
					Text("•")
						.font(.largeTitle)
						.foregroundColor(.orange)
				}
			}
		}
		.menuBarExtraStyle(.window)
		
	}
}

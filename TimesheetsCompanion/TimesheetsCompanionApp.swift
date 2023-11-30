//
//  TimesheetsCompanionApp.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/19/23.
//
//
import SwiftUI
import FluidMenuBarExtra

@main
struct TimesheetsCompanionApp: App {
	@NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
	
	var body: some Scene {
		Settings {
			EmptyView()
		}
	}
}

class AppDelegate: NSObject, NSApplicationDelegate {
	var screenSize: CGSize = {
		guard let size = NSScreen.main?.visibleFrame.size else {
			return .zero
		}

		return size
	}()
	@State private var navigation = AppNavigation()
	@State private var supabase = SupabaseManager()
	private var menuBarExtra: FluidMenuBarExtra?
	
	func applicationDidFinishLaunching(_ notification: Notification) {
		self.menuBarExtra = FluidMenuBarExtra(title: "My Menu", systemImage: "clock") {
			ContentView()
				.frame(width: self.screenSize.width / 8)
				.environment(self.supabase)
				.environment(self.navigation)
		}
	}
}

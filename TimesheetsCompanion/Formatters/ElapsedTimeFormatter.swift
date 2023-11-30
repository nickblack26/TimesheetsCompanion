//
//  ElapsedTimeFormatter.swift
//  TimesheetsCompanion
//
//  Created by Nick on 10/2/23.
//

import Foundation

class ElapsedTimeFormatter: Formatter {
	let componentsFormatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.hour, .minute, .second]
		formatter.zeroFormattingBehavior = .pad
		return formatter
	}()
	
	override func string(for value: Any?) -> String? {
		guard let time = value as? TimeInterval else {
			return nil
		}
		
		guard let formattedString = componentsFormatter.string(from: time) else { return nil }
		
//		if showSubseconds {
//			let hundreths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
//			let decimalSeperator = Locale.current.decimalSeparator ?? "."
//			return String(format: "%@%@%0.2d", formattedString, decimalSeperator, hundreths)
//		}
		
		return formattedString
	}
}

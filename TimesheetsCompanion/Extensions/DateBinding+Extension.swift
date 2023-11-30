//
//  DateBinding+Extension.swift
//  TimesheetsCompanion
//
//  Created by Nick on 10/5/23.
//

import Foundation
import SwiftUI

extension Binding where Value == Date? {
	func toNonOptional() -> Binding<Date> {
		return Binding<Date>(
			get: {
				return self.wrappedValue ?? Date()
			},
			set: {
				self.wrappedValue = $0
			}
		)
	}
}

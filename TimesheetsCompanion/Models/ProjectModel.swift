//
//  ProjectModel.swift
//  TimesheetsCompanion
//
//  Created by Nick on 10/5/23.
//

import Foundation

struct ProjectModel: Identifiable, Codable {
	var id: UUID
	var name: String
	var business: UUID?
	var description: String?
	var client: ClientModel?
	var maximum_revisions: Int8?
	var start_date: Date?
	var end_date: Date?
	var hour_cap: Int8?
}

//
//  TimeEntryModel.swift
//  TimesheetsCompanion
//
//  Created by Nick on 9/29/23.
//

import Foundation

struct TimeEntryModel: Identifiable, Codable {
	var id: UUID
	var start_time: Date
	var user: UserModel?
	var end_time: Date?
	var project: ProjectModel?
	var client: ClientModel?
	var activity: String?
	
	init(id: UUID, start_time: Date, user: UserModel? = nil, end_time: Date? = nil, project: ProjectModel? = nil, client: ClientModel? = nil, activity: String? = nil) {
		self.id = id
		self.start_time = start_time
		self.user = user
		self.end_time = end_time
		self.project = project
		self.client = client
		self.activity = activity
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		self.id = try container.decode(UUID.self, forKey: .id)
		self.start_time = dateFormatter.date(from: try container.decode(String.self, forKey: .start_time)) ?? Date()
		let timer = try container.decodeIfPresent(String.self, forKey: .end_time)
		self.end_time = timer != nil ? dateFormatter.date(from: try container.decode(String.self, forKey: .end_time)) : nil
		self.user = try container.decodeIfPresent(UserModel.self, forKey: .user)
		self.end_time = try container.decodeIfPresent(Date.self, forKey: .end_time)
		self.project = try container.decodeIfPresent(ProjectModel.self, forKey: .project)
		self.client = try container.decodeIfPresent(ClientModel.self, forKey: .client)
		self.activity = try container.decodeIfPresent(String.self, forKey: .activity)
	}
}

struct TimeEntryInsertModel: Codable {
	let id: UUID?
	let user: UUID?
	let start_time: Date?
	let end_time: Date?
	let project: UUID?
	let client: UUID?
	let activity: String?
	
	init(id: UUID? = nil, user: UUID? = nil, start_time: Date? = nil, end_time: Date? = nil, project: UUID? = nil, client: UUID? = nil, activity: String? = nil) {
		self.id = id
		self.user = user
		self.start_time = start_time
		self.end_time = end_time
		self.project = project
		self.client = client
		self.activity = activity
	}
}

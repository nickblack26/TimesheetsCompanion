//
//  UserModel.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import Foundation

struct UserModel: Identifiable, Codable {
    let id: UUID
    let first_name: String?
    let last_name: String?
    let image_url: String?
    let username: String?
    let stripe_id: String?
}

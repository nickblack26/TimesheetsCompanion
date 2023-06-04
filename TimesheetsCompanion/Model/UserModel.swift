//
//  UserModel.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import Foundation

struct UserModel: Identifiable, Codable {
    let id: Int
    let first_name: String
    let last_name: String
    let display_name: String
    let group_id: Int
    let active: Bool
    let profile_image_url: String
}

//
//  JobcodeModel.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/21/23.
//

import Foundation

struct JobcodeModel: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let type: String
    let active: Bool
    
    init(id: Int, name: String, type: String, active: Bool) {
        self.id = id
        self.name = name
        self.type = type
        self.active = active
    }
}

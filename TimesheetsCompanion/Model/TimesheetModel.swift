//
//  TimesheetModel.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/19/23.
//

import Foundation

struct TimesheetModel: Identifiable, Codable, Hashable {
    var id: Int
    var user_id: Int
    var jobcode_id: Int
    var start: Date
    var end: Date?
    var duration: Int
    var date: Date
    var type: String
    var on_the_clock: Bool
    
    init(id: Int, user_id: Int, jobcode_id: Int, start: String, end: String, duration: Int, date: String, type: String, on_the_clock: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.start = dateFormatter.date(from: start) ?? Date()
    
        self.end = dateFormatter.date(from: end) ?? nil
                
        self.id = id
        self.user_id = user_id
        self.jobcode_id = jobcode_id
        self.duration = duration
        self.type = type
        self.on_the_clock = on_the_clock
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.date(from: date) ?? Date()
    }
        
    init(user_id: Int, jobcode_id: Int, start: Date = Date(), end: Date?, duration: Int = 0, date: Date = Date(), type: String, on_the_clock: Bool = true, created_by_user_id: Int) {
        self.id = Int.random(in: 0..<10000)
        self.user_id = user_id
        self.jobcode_id = jobcode_id
        self.start = start
        self.end = end ?? nil
        self.duration = duration
        self.date = date
        self.type = type
        self.on_the_clock = on_the_clock
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        // Decode the string coming in from the decoder into a Date
        self.start = dateFormatter.date(from: try container.decode(String.self, forKey: .start)) ?? Date()
        self.end = dateFormatter.date(from: try container.decode(String.self, forKey: .end)) ?? nil
        
        // Decode the string coming in from the decoder into a Date
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.date(from: try container.decode(String.self, forKey: .date)) ?? Date()
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.user_id = try container.decode(Int.self, forKey: .user_id)
        self.jobcode_id = try container.decode(Int.self, forKey: .jobcode_id)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.type = try container.decode(String.self, forKey: .type)
        self.on_the_clock = try container.decode(Bool.self, forKey: .on_the_clock)
    }
}

struct TimesheetServerModel: Codable {
    var id: Int? = nil
    var user_id: Int
    var jobcode_id: Int
    var type: String
    var start: String
    var end: String
    var duration: Int
    var date: String
    
    init(model: TimesheetModel, update: Bool = false) {
        if update {
            self.id = model.id
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        self.user_id = model.user_id
        self.jobcode_id = model.jobcode_id
        self.type = model.type
        self.start = dateFormatter.string(from: model.start)
        
        if model.end != nil {
            self.end = dateFormatter.string(from: model.end!)
        } else {
            self.end = ""
        }
        
        self.duration = model.duration
        self.date = dateFormatter.string(from: model.date)
    }
}

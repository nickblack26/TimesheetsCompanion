//
//  WorkingReportViewModel.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import Foundation


struct User: Codable, Identifiable {
    var id: Int
    var first_name: String
    var last_name: String
    var display_name: String
    var group_id: Int?
    var active: Bool
    var username: String?
    var profile_image_url: String?
}

struct ReportModel: Codable, Identifiable {
    var id: Int { user_id }
    var user_id: Int
    var on_the_clock: Bool
    var timesheet_id: Int
    var jobcode_id: Int
    var group_id: Int
    var shift_seconds: Int
    var day_seconds: Int
}

@MainActor
class WorkingReportViewModel: ObservableObject {
    @Published var currentWorkers: [ReportModel] = []
    @Published var users: [UserModel] = []
    @Published var timesheets: [TimesheetModel] = []
    @Published var jobcodes: [JobcodeModel] = []
//    private let manager = TSheetManager.shared
    
    init() {
        Task {
//            let result = try await manager.fetchWorkersReport()
        }
    }
}

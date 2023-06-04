//
//  ClientsListViewModel.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import Foundation

@MainActor
class JobcodesListViewModel: ObservableObject {
    @Published var jobcodes: [JobcodeModel] = []
    let manager = TSheetManager()
    
    init() {        
        Task {
            let response = try await manager.fetchAllJobcodes()
            self.jobcodes = response?.results.jobcodes?.map { $1 } ?? []
        }
    }
	
	func setJobcode(jobcode: JobcodeModel) {
		manager.currentJob = jobcode
	}
}

//
//  LoggedHoursViewModel.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 27/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoggedHoursViewModelDelegate: NSObjectProtocol {
    func loggedHoursUpdated(timeEntries: [ProjectTimeEntry])
}

class LoggedHoursViewModel {
    
    fileprivate let service = TimeEntryService()
    fileprivate let enumService = EnumerationService()
    
    private let disposeBag = DisposeBag()
    
    weak var delegate: LoggedHoursViewModelDelegate?
    
    var activities: [TimeEntryActivity] = []
    
    var startFilterDate: Date?
    var endFilterDate: Date = Date()
    
    var totalHoursString: String {
        let totalHours: Double = projectTimeEntries.reduce(0) { (result, timeEntry)  in
            return result + timeEntry.hoursLogged
        }
        return "\(totalHours)"
    }
    
    var projectTimeEntries: [ProjectTimeEntry] = [] {
        didSet {
            delegate?.loggedHoursUpdated(timeEntries: projectTimeEntries)
        }
    }
    
    var timeEntries: [TimeEntry] = [TimeEntry]() {
        didSet {
            // gets all the projects from the time entries
            let allProjects = timeEntries.compactMap { timeEntry in
                return timeEntry.project
            }
            
            // gets all the unique proejcts
            let projects: Set<TimeEntry.Project> = Set.init(allProjects)

            // calculates the total hours logged for each project
            let projectTimeEntries = projects.map { (project) -> ProjectTimeEntry in
                let projectHours: Double = timeEntries.reduce(0) { (result, entry) in
                    if entry.project.id == project.id {
                        return entry.hours + result
                    } else {
                        return result
                    }
                }
                
                // creates our cell view model for this project
                let projectTimeEntry = ProjectTimeEntry.init(project: project, hoursLogged: projectHours)
                return projectTimeEntry
            }
            
            self.projectTimeEntries = projectTimeEntries
        }
    }
    
    func logHours(for project: TimeEntry.Project, selectedActivity: TimeEntryActivity, duration: Float, comments: String?) {
        service.logHours(for: project,
                         selectedActivity: selectedActivity,
                         duration: duration,
                         comments: comments).subscribe(onNext: { _ in
                            self.fetchMyTimeEntries()
                         }, onError: { (error) in
                            print(error.localizedDescription)
                         }).disposed(by: disposeBag)
    }

    func fetchActivities() {
        enumService.timeEntryActivities()
            .subscribe(onNext: { (response) in
            self.activities = response.timeEntryActivities
        }, onError: { (error) in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    /// Fetches time entries for currently logged in user.
    func fetchMyTimeEntries() {
        let today = Date().string(custom: "YYYY-MM-dd")
        let filter = TimeEntriesRequest.init(date: today)
        service.fetchArray(filter: .mine(filter))
            .subscribe(onNext: { [weak self] (response) in
                self?.timeEntries = response.timeEntries
        }, onError: { (error) in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}

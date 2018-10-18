//
//  TimeEntryService.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 27/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxSwift


/// Definition
class TimeEntryService {
    
    let networking = Networking<TimeEntryApi>()
    
    enum TimeEntryType {
        case all
        case mine(TimeEntriesRequest)
    }
    
    func fetchArray(filter: TimeEntryType) -> Observable<TimeEntriesResponse> {
        let api = request(for: filter)
        return networking
            .request(to: api)
            .mapCodable()
    }
    
    func logHours(for project: TimeEntry.Project, selectedActivity: TimeEntryActivity, duration: Float, comments: String?) -> Observable<Void> {
        
        let timeEntry = PostLogHoursRequest.Request.init(hours: duration,
                                                           projectId: project.id,
                                                           activityId: selectedActivity.id,
                                                           comments: comments)
        let timeEntryRequest = PostLogHoursRequest.init(timeEntry: timeEntry)
        
        return networking
            .request(to: .createEntry(timeEntryRequest))
            .map { _ in Void() }
    }
}


// MARK: - Request Generation
extension TimeEntryService {
    
    fileprivate func request(for type: TimeEntryType) -> TimeEntryApi {
        switch type {
        case .all:
            return TimeEntryApi.visible
        case .mine(let filter):
            return TimeEntryApi.mine(filter)
        }
    }
}

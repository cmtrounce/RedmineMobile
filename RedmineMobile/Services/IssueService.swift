//
//  IssueService.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxSwift

class IssueService {
    
    private let networking = Networking<IssuesApi>()
    
    func issues(for timeEntryProject: TimeEntry.Project) -> Observable<IssuesResponse> {
        
        let requestData = ProjectIssuesRequest.init(projectId: timeEntryProject.id,
                                                    sort: .priority)
        
        return networking
            .request(to: .project(requestData))
            .mapCodable()
            .catchError({ (error) -> Observable<IssuesResponse> in
                print(error.localizedDescription)
                return Observable.just(IssuesResponse(issues: []))
            })
    }
    
    
}

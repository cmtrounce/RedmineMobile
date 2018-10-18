//
//  EnumerationService.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 14/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class EnumerationService {
    
    private let networking = Networking<EnumerationsApi>()
    
    func timeEntryActivities() -> Observable<ActivityResponse> {
        return networking
            .request(to: .timeEntryActivities)
            .mapCodable()
    }
    
    func issuePriorities() -> Observable<PrioritiesResponse> {
        return networking
            .request(to: .issuePriorities)
            .mapCodable()
    }
}

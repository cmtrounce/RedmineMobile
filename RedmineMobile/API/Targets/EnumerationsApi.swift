//
//  TimeEntryApi.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 27/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import Alamofire

enum EnumerationsApi {
    case timeEntryActivities
    case issuePriorities
}

extension EnumerationsApi: ApiController {
    
    var base: String {
        return "enumerations"
    }
    
    var path: String {
        switch self {
        case .timeEntryActivities:
            return base + "/time_entry_activities.json"
        case .issuePriorities:
            return base + "/issue_priorities.json"
        }
    }
    
    func parameters() throws -> Parameters? {
        return nil
    }
    
    var requiresAuthentication: Bool {
        return true
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var method: HTTPMethod {
        return .get
    }
}

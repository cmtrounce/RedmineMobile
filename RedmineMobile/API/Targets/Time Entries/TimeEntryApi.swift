//
//  TimeEntryApi.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 27/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import Alamofire

enum TimeEntryApi {
    case visible // authenticated user might not have access to all time entries - not sure.
    case mine(TimeEntriesRequest)
    case createEntry(PostLogHoursRequest)
}

extension TimeEntryApi: ApiController {
    
    var base: String {
        return "time_entries"
    }
    
    var path: String {
        switch self {
        
        case .visible:
            return base + ".json"
        case .mine:
            return base + ".json"
        case .createEntry:
            return base + ".json"
        }
    }
    
    func parameters() throws -> Parameters? {
        switch self {
        case .visible:
            return nil
        case .mine(let request):
            return ["user_id": "me",
                    "spent_on" : request.date]
        case .createEntry(let request):
            return try request.toJson()
        }
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
        switch self {
        case .visible, .mine:
            return .get
        case .createEntry:
            return .post
        }
    }
}

//
//  IssuesApi.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import Alamofire

enum IssuesApi {
    case project(ProjectIssuesRequest)
}

extension IssuesApi: ApiController {
    
    var base: String {
        return "issues"
    }
    
    var path: String {
        switch self {
        case .project:
            return base + ".json"
        }
    }
    
    func parameters() throws -> Parameters? {
        switch self {
        case .project(let request):
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
        return .get
    }
}

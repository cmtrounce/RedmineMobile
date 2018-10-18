//
//  AuthTargetAPI.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 26/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import Alamofire

enum ProjectApi {
    case all
    case byId(ByIdRequest)
}

extension ProjectApi: ApiController {
    
    var base: String {
        return "projects"
    }
    
    var path: String {
        switch self {
        case .all:
            return base + ".json"
        case .byId(let request):
            return base + "/\(request.id).json"
        }
    }
    
    func parameters() throws -> Parameters? {
        switch self {
        case .all:
            return [:]
        case .byId(let request):
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

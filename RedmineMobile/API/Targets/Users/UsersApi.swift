//
//  UsersApi.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 16/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import Alamofire

enum UsersApi {
    case current
}

extension UsersApi: ApiController {
    
    var base: String {
        return "users"
    }
    
    var path: String {
        switch self {
        case .current:
            return base + "/current.json"
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

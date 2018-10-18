//
//  File.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 16/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation

enum Errors {
    
    static let invalidCredentials = NSError.init(domain: "AuthService",
                                                 code: 400,
                                                 userInfo: [NSLocalizedDescriptionKey: "No credentials provided for authorized call"])
    
}

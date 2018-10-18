//
//  LogHoursRequest.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 14/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation



struct PostLogHoursRequest: Codable {
    
    struct Request: Codable {
        let hours: Float
        let projectId: Int
        let activityId: Int
        let comments: String?
    }
    
    let timeEntry: Request
}

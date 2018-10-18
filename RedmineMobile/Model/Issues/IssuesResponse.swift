//
//  IssuesResponse.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation

struct IssuesResponse: Codable {
    let issues: [Issue]
}

enum IssueSortType: String, Codable {
    case priority = "priority:desc"
}

struct Issue: Codable {
    let id: Int
    let project, tracker, status, priority, author : Reference
    let assignedTo, fixedVersion: Reference?
    let subject: String
    let description, startDate: String?
    let doneRatio: Int
    let createdOn, updatedOn: String
    
    struct Reference: Equatable, Hashable, Codable  {
        let id: Int
        let name: String
        
        static func ==(lhs: Reference, rhs: Reference) -> Bool {
            let areEqual = lhs.id == rhs.id
            return areEqual
        }
    
    }
}

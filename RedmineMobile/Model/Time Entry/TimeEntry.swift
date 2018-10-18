//
//  TimeEntry.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 27/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation

struct TimeEntry: Codable {
    let id: Int
    let project: Project
    let issue: Issue?
    let user: User
    let activity: Activity
    let hours: Double
    let spentOn, createdOn, updatedOn: String
    let comments: String?
  
    struct Activity: Codable {
        let id: Int
        let name: String
    }
    
    struct Project: Codable, Equatable, Hashable {
        
        let id: Int
        let name: String
        
        static func ==(lhs: TimeEntry.Project, rhs: TimeEntry.Project) -> Bool {
            return lhs.id == rhs.id
        }
        
        var hashValue: Int {
            get {
                return id.hashValue
            }
        }
    }
    
    struct User: Codable {
        let id: Int
        let name: String
    }
    
    struct Issue: Codable {
        let id: Int
    }
}



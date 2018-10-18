//
//  Project.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 26/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation

struct Project: Codable {
    let id: Int
    let name, identifier, description: String
    let status: Int
    let parent: ParentProject?
    let createdOn, updatedOn: String
}

struct ParentProject: Codable {
    let id: Int
    let name: String
}

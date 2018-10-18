//
//  IssuePriorities.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
struct PrioritiesResponse: Codable {
    let issuePriorities: [IssuePriority]
}

struct IssuePriority: Codable {
    let id: Int
    let name: String
    let isDefault: Bool
}

//
//  ProjectIssuesRequest.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation

struct ProjectIssuesRequest: Codable {
    let projectId: Int
    let sort: IssueSortType?
    let limit = 100
}



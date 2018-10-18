//
//  TimeEntryActivity.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation

struct ActivityResponse: Codable {
    let timeEntryActivities: [TimeEntryActivity]
}

struct TimeEntryActivity: Codable {
    let id: Int
    let name: String
}

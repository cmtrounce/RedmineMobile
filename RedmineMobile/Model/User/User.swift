//
//  User.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 16/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let user: User
}

struct User: Codable {
    let id: Int
    let login, firstname, lastname, createdOn: String
    let lastLoginOn, apiKey: String
}

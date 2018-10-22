//
//  UserService.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 16/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxSwift

class UserService {
    
    static let shared = UserService()
    
    private let networking = Networking<UsersApi>()

    func fetchCurrent() -> Observable<UserResponse> {
        return networking
            .request(to: .current)
            .mapCodable()
    }
}

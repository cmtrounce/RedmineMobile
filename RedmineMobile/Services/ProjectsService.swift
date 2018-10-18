//
//  ProjectsService.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 26/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxSwift

class ProjectsService {
    
    let networking = Networking<ProjectApi>()
    
    func fetchAll() -> Observable<ProjectsResponse> {
       return networking
        .request(to: .all)
        .mapCodable()
    }
}

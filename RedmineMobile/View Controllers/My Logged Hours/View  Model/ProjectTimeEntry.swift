//
//  ProjectTimeEntry.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 27/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation

class ProjectTimeEntry {
    var project: TimeEntry.Project
    var hoursLogged: Double
    
    init(project: TimeEntry.Project, hoursLogged: Double) {
        self.project = project
        self.hoursLogged = hoursLogged
    }
}

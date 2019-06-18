//
//  TeamResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/12/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

struct TeamResource: APIResourceType {
    
    typealias Model = Team
    
    let path: String
    
    init(id: String) {
        path = "teams/\(id)"
    }
    
    init(personID: String, planPersonID: String) {
        path = "people/\(personID)/plan_people/\(planPersonID)/team"
    }
    
    init(personID: String, scheduleID: String) {
         path = "people/\(personID)/schedules/\(scheduleID)/team"
    }
}

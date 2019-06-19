//
//  TeamResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/12/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

typealias TeamResource = SingleResource<Team>

extension Team: FetchableByIdentifier {
    public static var collectionPath: String {
        return "teams"
    }
}

extension SingleResource where Model == Team {
    
    init(personID: ResourceIdentifier<Person>, planPersonID: ResourceIdentifier<PlanPerson>) {
        self.init(path: "people/\(personID.id)/plan_people/\(planPersonID.id)/team")
    }
    
    init(personID: ResourceIdentifier<Person>, scheduleID: String) {
         self.init(path: "people/\(personID.id)/schedules/\(scheduleID)/team")
    }
}

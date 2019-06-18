//
//  Team.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/12/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

public struct Team: ResourceDecodable {
    public var id: ResourceIdentifier<Team>
    public var name: String
    public var orderIndex: Int? // How the team should be ordered with other teams.
    public var doesScheduleToAllTimes: Bool
    
    public var serviceTypeID: ResourceIdentifier<ServiceType>
    //let people: [People]? // Trully optional, nil unless included.
    //let perPersonPositionAssignments: [PersonTeamPostionAssignment]? // Trully optional, nil unless included.
    //let teamPositions: [TeamPosition] // Trully optional, nil unless included.
    
    public init(resource: Resource) throws {
        id = try resource.identifer.specialize()
        
        name = try resource.attribute(for: "name").asString()
        orderIndex = try resource.attributeIfPresent(for: "sequence")?.asInt()
        doesScheduleToAllTimes = try resource.attribute(for: "schedule_to").asString() == "plan"
        serviceTypeID = try resource.toOneRelationship(for: "service_type")
    }
}

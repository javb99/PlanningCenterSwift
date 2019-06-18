//
//  Plan.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/5/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import GenericJSON

public struct Plan: ResourceDecodable {
    
    public var id: ResourceIdentifier<Plan>
    public var title: String?
    public var sortDate: Date?
    
    public var serviceTypeID: ResourceIdentifier<ServiceType>
    /// Only exists if filled from the outside.
    public var serviceType: ServiceType?
    
//    public let itemsCount: Int
    
    /// The count of the number of unique people scheduled to the plan. Doesn't count anyone twice.
    public var planPeopleCount: Int
    
    public var neededPositionsCount: Int
    
    public var timeIDs: [ResourceIdentifier<PlanTime>]
    public var times: [ResourceIdentifier<PlanTime>: PlanTime]?
    
    public init(resource: Resource) throws {
        id = try resource.identifer.specialize()
        
        title = try resource.attributeIfPresent(for: "title")?.asString()
        sortDate = try resource.attribute(for: "sort_date").asDate()
        planPeopleCount = try resource.attribute(for: "plan_people_count").asInt()
        neededPositionsCount = try resource.attribute(for: "needed_positions_count").asInt()

        //teamID = resource.toOneRelationship(for: "team").id
        serviceTypeID = try resource.toOneRelationship(for: "service_type")
        timeIDs = try resource.toManyRelationship(for: "plan_times")
    }
}

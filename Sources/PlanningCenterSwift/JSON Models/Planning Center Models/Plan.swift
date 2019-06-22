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
    
    // MARK: - Attributes
    
    public var title: String?
    
    /// A  date (though, time is not necessarily a service time) to sort plans by.
    public var sortDate: Date?
    
    /// The long form of the service dates. Ex. "June 26 & 27, 2019"
    public var datesDescription: String
    
    /// The short form of the service dates. Ex. "Jun 26 & 27"
    public var shortDatesDescription: String
    
    public var serviceTypeID: ResourceIdentifier<ServiceType>
    /// Only exists if filled from the outside.
    public var serviceType: ServiceType?
    
//    public let itemsCount: Int
    
    /// The count of the number of unique people scheduled to the plan. Doesn't count anyone twice.
    public var planPeopleCount: Int
    
    public var neededPositionsCount: Int
    
    // MARK: - Relationships
    
    public var timeIDs: [ResourceIdentifier<PlanTime>]?
    public var times: [ResourceIdentifier<PlanTime>: PlanTime]?
    
    public var createdBy: ResourceIdentifier<Person>
    public var updatedBy: ResourceIdentifier<Person>
    
    public init(resource: Resource) throws {
        id = try resource.identifer.specialize()
        
        title = try resource.attributeIfPresent(for: "title")?.asString()
        sortDate = try resource.attribute(for: "sort_date").asDate()
        datesDescription = try resource.attribute(for: "dates").asString()
        shortDatesDescription = try resource.attribute(for: "short_dates").asString()
        planPeopleCount = try resource.attribute(for: "plan_people_count").asInt()
        neededPositionsCount = try resource.attribute(for: "needed_positions_count").asInt()

        serviceTypeID = try resource.toOneRelationship(for: "service_type")
        createdBy = try resource.toOneRelationship(for: "created_by")
        updatedBy = try resource.toOneRelationship(for: "updated_by")
        timeIDs = resource.toManyRelationshipIfPresent(for: "plan_times")
    }
}

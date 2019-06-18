//
//  PlanTime.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/11/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import GenericJSON

public struct PlanTime: ResourceDecodable {
    
    public var id: ResourceIdentifier<PlanTime>
    public var name: String?
    public var startsAt: Date
    public var endsAt: Date?
    
    public enum `Type`: String {
        case service
        case rehearsal
        case other
    }
    public let type: Type
    //let liveStartsAt: Date?
    //let liveEndsAt: Date?
    // Edited dates
    
    public init(resource: Resource) throws {
        id = try resource.identifer.specialize()
        
        name = try resource.attributeIfPresent(for: "name")?.asString()
        startsAt = try resource.attribute(for: "starts_at").asDate()
        endsAt = try resource.attribute(for: "ends_at").asDate()
        
        guard let type = try Type(rawValue: resource.attribute(for: "time_type").asString()) else {
            throw ResourceDecodeError.failedToParseAttribute("time_type")
        }
        self.type = type
    }
}

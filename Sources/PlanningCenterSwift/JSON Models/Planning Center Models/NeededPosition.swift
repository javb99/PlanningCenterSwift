//
//  NeededPosition.swift
//  ServicesScheduler
//
//  Documentation at:
//  https://developer.planning.center/docs/#/apps/services/2018-11-01/vertices/needed_position
//  Created by Joseph Van Boxtel on 1/5/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import JSONAPISpec

extension Models {
    public struct NeededPosition {}
}

extension Models.NeededPosition: ResourceProtocol {
    
    public struct Attributes: Codable {
        
        enum CodingKeys: String, CodingKey {
            case quantity
            case positionName = "team_position_name"
            case scheduledTo = "scheduled_to"
        }
        
        public var quantity: Int
        
        public var positionName: String
        
        public var scheduledTo: ScheduledTo
    }
    
    public struct Relationships: Codable {
        public var team: ToOneRelationship<Models.Team>
        public var plan: ToOneRelationship<Models.Plan>
        /// Present when scheduled to is `time`
        public var time: ToOneRelationship<Models.PlanTime>
    }
    
    /// A time that a needed position can be scheduled to. Either all times or a specific time ID.
    public enum ScheduledTo: String, Codable {
        
        case plan
        
        /// Get the time ID with the `time` relationship on the resource.
        case time
    }
    
    public typealias Links = Empty
    
    public typealias Meta = Empty
}

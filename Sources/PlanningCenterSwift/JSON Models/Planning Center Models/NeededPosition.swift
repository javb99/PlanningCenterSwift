//
//  NeededPosition.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/5/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//
//
//import Foundation
//import GenericJSON
//
///// A time that a needed position can be scheduled to. Either all times or a specific time ID.
//public enum Time: Hashable, Equatable {
//    
//    case all
//    case time(ResourceIdentifier<PlanTime>)
//    
//    public var timeID: ResourceIdentifier<PlanTime>? {
//        switch self {
//        case .all:
//            return nil
//        case let .time(t):
//            return t
//        }
//    }
//    
//    public var description: String {
//        switch self {
//        case .all:
//            return "all"
//        case let .time(t):
//            return t.id
//        }
//    }
//    
//    public static func == (lhs: Time, rhs: Time) -> Bool {
//        switch (lhs,rhs) {
//        case (.all, .all):
//            return true
//        case (.time(let a), .time(let b)):
//            return a == b
//        default:
//            return false
//        }
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(description)
//    }
//}
//
//public struct NeededPosition: ResourceDecodable {
//    
//    public var quantity: Int
//    public var positionName: String
//    
//    public var scheduledTo: Time
//    
//    public var id: ResourceIdentifier<NeededPosition>
//    public var teamID: ResourceIdentifier<Team>
//    public var planID: ResourceIdentifier<Plan>
//    
//    public init(resource: Resource) throws {
//        id = try resource.identifer.specialize()
//        
//        quantity = try resource.attribute(for: "quantity").asInt()
//        positionName = try resource.attribute(for: "team_position_name").asString()
//        
//        teamID = try resource.toOneRelationship(for: "team")
//        planID = try resource.toOneRelationship(for: "plan")
//        
//        let scheduledTo = try resource.attribute(for: "scheduled_to").asString()
//        switch scheduledTo {
//        case "plan":
//            self.scheduledTo = .all
//        case "time":
//            self.scheduledTo = .time(try resource.toOneRelationship(for: "time"))
//        default:
//            // Maybe just default to .all or return nil
//            throw ResourceDecodeError.failedToParseAttribute("scheduled_to")
//        }
//    }
//}

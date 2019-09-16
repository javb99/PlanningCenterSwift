//
//  PlanTime.swift
//
//  See API documentation here: https://developer.planning.center/docs/#/apps/services/2018-11-01/vertices/plan_time
//
//  Created by Joseph Van Boxtel on 1/11/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//
//
import Foundation
import JSONAPISpec

// MARK: - Related API

public struct PlanTime {
    
    public static var pluralName: String = "folders"
    
    public var id: ResourceIdentifier<PlanTime>
    
    public init(id: ResourceIdentifier<PlanTime>) {
        self.id = id
    }
}

// MARK: - Structure

extension PlanTime: ResourceProtocol {
    
    public enum `Type`: String, Codable {
        case service
        case rehearsal
        case other
    }
    
    public struct Attributes: Codable {
        
        enum CodingKeys: String, CodingKey {
            case name
            case type
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case startsAt = "starts_at"
            case endsAt = "ends_at"
            case liveStartsAt = "live_starts_at"
            case liveEndsAt = "live_ends_at"
            case teamReminders = "team_reminders"
        }
        
        public var name: String?
        
        public var type: Type
        
        public var createdAt: Date?
        
        public var updatedAt: Date?
        
        public var startsAt: Date
        
        public var endsAt: Date?
        
        public var liveStartsAt: Date?
        
        public var liveEndsAt: Date?
        
        /// TeamID to days notice.
        public var teamReminders: [String: Int]?
    }
    
    public struct Relationships: Codable {
        
//        enum CodingKeys: String, CodingKey {
//            case assignedTeams = "assigned_teams"
//        }
//
//        public var assignedTeams: ResourceIdentifier<Folder>? // To-many
    }
    
    public typealias Links = Empty
    
    public typealias Meta = Empty
}

//
//  Team.swift
//
//  See the API documentation at
//  https://developer.planning.center/docs/#/apps/services/2018-11-01/vertices/team
//
//  Created by Joseph Van Boxtel on 1/12/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import JSONAPISpec

extension Models {
    public struct Team {}
}

extension Models.Team: ResourceProtocol, SingularNameProviding {
    
    public static let singularResourceName: String = "team"

    fileprivate enum ScheduleTo : String, Codable {
        case plan
        case time
    }

    public struct Attributes: Codable {

        enum CodingKeys: String, CodingKey {
            case name
            case sequenceIndex = "sequence"
            case scheduleTo = "schedule_to"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case defaultStatus = "default_status"
            case defaultPrepareNotifications = "default_prepare_notifications"
            case assignedDirectly = "assigned_directly"
        }

        public var name: String?

        public var sequenceIndex: Int?

        fileprivate var scheduleTo: ScheduleTo

        public var createdAt: Date?

        public var updatedAt: Date?

        public var defaultStatus: Models.PlanPerson.Status?

        public var defaultPrepareNotifications: Bool?

        public var assignedDirectly: Bool?
    }

    public struct Relationships: Codable {

        enum CodingKeys: String, CodingKey {
            case serviceType = "service_type"
        }

        public var serviceType: ToOneRelationship<Models.ServiceType>
    }

    public typealias Links = Empty

    public typealias Meta = Empty
}

extension Models.Team.Attributes {

    public var isSplit: Bool {
        get { scheduleTo == .time }
        set { scheduleTo = newValue ? .time : .plan }
    }
}

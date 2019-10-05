//
//  PlanPerson.swift
//  ServicesScheduler
//
//  Documentation at:
//  https://developer.planning.center/docs/#/apps/services/2018-11-01/vertices/plan_person
//
//  Created by Joseph Van Boxtel on 1/4/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import JSONAPISpec

extension Models {
    public struct PlanPerson {}
}

extension Models.PlanPerson {
    public enum Status: String, Codable {
        case unconfirmed = "U"
        case confirmed = "C"
        case declined = "D"
    }
}

extension Models.PlanPerson: ResourceProtocol {

    public struct Attributes: Codable {

        public var status: Status
        public var name: String
        public var positionName: String
        public var photoThumbnail: URL
        public var createdAt: Date
        public var updatedAt: Date
        public var notes: String?
        public var declineReason: String?
        public var statusUpdatedAt: Date?
        public var notificationSentAt: Date?
        public var isNotificationPrepared: Bool
        public var canAcceptPartial: Bool
    }

    public struct Relationships: Codable {

//        public var person: ToOneRelationship<Models.Person>
        
        public var plan: ToOneRelationship<Models.Plan>
        
        public var serviceType: ToOneRelationship<Models.ServiceType>

//        public var respondsTo: ToOneRelationship<Models.Person>
        
//        public var times: ToManyRelationship<Models.PlanTime>
        
//        public var serviceTypes: ToManyRelationship<Models.PlanTime>
    }

    public typealias Links = Empty
    public typealias Meta = Empty
}

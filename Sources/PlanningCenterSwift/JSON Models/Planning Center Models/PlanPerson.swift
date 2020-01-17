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
public typealias MPlanPerson = Resource<Models.PlanPerson>

extension MPlanPerson {
    init(id: MPlanPerson.ID,
         status: Models.PlanPerson.Status,
         name: String,
         positionName: String? = nil,
         photoThumbnail: URL,
         createdAt: Date = Date(),
         updatedAt: Date,
         notes: String? = nil,
         declineReason: String? = nil,
         statusUpdatedAt: Date? = nil,
         notificationSentAt: Date? = nil,
         isNotificationPrepared: Bool,
         canAcceptPartial: Bool
    ) {
        self.init(
            identifer: id,
            attributes: .init(
                status: status,
                name: name,
                positionName: positionName,
                photoThumbnail: photoThumbnail,
                createdAt: createdAt,
                updatedAt: updatedAt,
                notes: notes,
                declineReason: declineReason,
                statusUpdatedAt: statusUpdatedAt,
                notificationSentAt: notificationSentAt,
                isNotificationPrepared: isNotificationPrepared,
                canAcceptPartial: canAcceptPartial
            )
        )
    }
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
        
        enum CodingKeys: String, CodingKey {
            case status
            case name
            case positionName = "team_position_name"
            case photoThumbnail = "photo_thumbnail"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case notes
            case declineReason = "decline_reason"
            case statusUpdatedAt = "status_updated_at"
            case notificationSentAt = "notification_sent_at"
            case isNotificationPrepared = "prepare_notification"
            case canAcceptPartial = "can_accept_partial"
        }

        public var status: Status
        public var name: String
        public var positionName: String? // I don't know why it's optional but it is.
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
        
        enum CodingKeys: String, CodingKey {
            case person
            case plan
            case serviceType = "service_type"
            case team
            case respondsTo = "responds_to"
        }

        public var person: ToOneRelationship<Models.Person>
        
        public var plan: ToOneRelationship<Models.Plan>
        
        public var serviceType: ToOneRelationship<Models.ServiceType>
        
        public var team: ToOneRelationship<Models.Team>

        public var respondsTo: ToOneRelationship<Models.Person>
        
//        public var times: ToManyRelationship<Models.PlanTime>
        
//        public var serviceTypes: ToManyRelationship<Models.PlanTime>
    }

    public typealias Links = Empty
    public typealias Meta = Empty
}

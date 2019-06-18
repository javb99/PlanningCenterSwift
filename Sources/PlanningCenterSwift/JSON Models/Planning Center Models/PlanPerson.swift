//
//  PlanPerson.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/4/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import GenericJSON

public struct PlanPerson: ResourceDecodable {
    
    public var id: ResourceIdentifier<PlanPerson>
    public var status: Status
    public var name: String
    public var positionName: String
    public var photoThumbnail: URL
    //public var createdAt: Date
    //public var updatedAt: Date
    //public var notes: String?
    //public var declineReason: String?
    //public var statusUpdatedAt: Date?
    //public var notificationSentAt: Date?
    public var isNotificationPrepared: Bool
    //public var canAcceptPartial: Bool
    
    // Relationships
    public var personID: ResourceIdentifier<PlanPerson>
    public var planID: ResourceIdentifier<Plan>
    public var teamID: ResourceIdentifier<Team>
    public var timeIDs: [ResourceIdentifier<PlanTime>]
    
    public enum Status: String {
        case unconfirmed = "U"
        case confirmed = "C"
        case declined = "D"
    }
    
    public init(resource: Resource) throws {
        id = try resource.identifer.specialize()
        
        guard let status = try PlanPerson.Status(rawValue: resource.attribute(for: "status").asString()) else {
            throw ResourceDecodeError.failedToParseAttribute("'status' didn't match an enum case.")
        }
        self.status = status
        
        positionName = try resource.attribute(for: "team_position_name").asString()
        name = try resource.attribute(for: "name").asString()
        photoThumbnail = try resource.attribute(for: "photo_thumbnail").asURL()
        isNotificationPrepared = try resource.attribute(for: "prepare_notification").asBool()
        // Relationships
        personID = try resource.toOneRelationship(for: "person")
        teamID = try resource.toOneRelationship(for: "team")
        planID = try resource.toOneRelationship(for: "plan")
        timeIDs = try resource.toManyRelationship(for: "times")
    }
}

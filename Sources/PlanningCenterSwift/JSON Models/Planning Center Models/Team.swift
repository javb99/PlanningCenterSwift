//
//  Team.swift
//
//  See the API documentation at https://developer.planning.center/docs/#/apps/services/2018-11-01/vertices/team
//
//  Created by Joseph Van Boxtel on 1/12/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import JSONAPISpec

// MARK: - Related API
//
//public struct Team{//}: CRUDable {
////
////    public static var pluralName: String = "teams"
////
////    public var id: ResourceIdentifier<Team>
////
////    public init(id: ResourceIdentifier<Team>) {
////        self.id = id
////    }
////
////    public var subfolders: AnyCodableNetworkTransaction<Empty, ResourceCollectionDocument<Folder>> {
////        return .init(path: instancePath + "/folders")
////    }
////
////    public var serviceTypes: AnyCodableNetworkTransaction<Empty, ResourceCollectionDocument<ServiceType>> {
////        return .init(path: instancePath + "/service_types")
////    }
//}
//
//// MARK: - Structure
//
//extension Team: ResourceProtocol {
//
//    fileprivate enum ScheduleTo : String, Codable {
//        case plan
//        case time
//    }
//
//    public struct Attributes: Codable {
//
//        enum CodingKeys: String, CodingKey {
//            case name
//            case sequenceIndex = "sequence"
//            case scheduleTo = "schedule_to"
//            case createdAt = "created_at"
//            case updatedAt = "updated_at"
//            case defaultStatus = "default_status"
//            case defaultPrepareNotifications = "default_prepare_notifications"
//            case assignedDirectly = "assigned_directly"
//        }
//
//        public var name: String?
//
//        public var sequenceIndex: Int?
//
//        fileprivate var scheduleTo: ScheduleTo
//
//        public var createdAt: Date?
//
//        public var updatedAt: Date?
//
//        public var defaultStatus: PositionStatus?
//
//        public var defaultPrepareNotifications: Bool?
//
//        public var assignedDirectly: Bool?
//    }
//
//    public struct Relationships: Codable {
//
//        enum CodingKeys: String, CodingKey {
//            case serviceType = "service_type"
//        }
//
//        public var serviceType: ToOneRelationship<Models.ServiceType>?
//    }
//
//    public typealias Links = Empty
//
//    public typealias Meta = Empty
//}
//
//extension Team.Attributes {
//
//    public var isSplit: Bool {
//        get { scheduleTo == .time }
//        set { scheduleTo = newValue ? .time : .plan }
//    }
//}
////
////public struct Team: ResourceDecodable {
////    public var id: ResourceIdentifier<Team>
////    public var name: String
////    public var orderIndex: Int? // How the team should be ordered with other teams.
////    public var doesScheduleToAllTimes: Bool
////
////    public var serviceTypeID: ResourceIdentifier<ServiceType>
////    //let people: [People]? // Trully optional, nil unless included.
////    //let perPersonPositionAssignments: [PersonTeamPostionAssignment]? // Trully optional, nil unless included.
////    //let teamPositions: [TeamPosition] // Trully optional, nil unless included.
////
////    public init(resource: Resource) throws {
////        id = try resource.identifer.specialize()
////
////        name = try resource.attribute(for: "name").asString()
////        orderIndex = try resource.attributeIfPresent(for: "sequence")?.asInt()
////        doesScheduleToAllTimes = try resource.attribute(for: "schedule_to").asString() == "plan"
////        serviceTypeID = try resource.toOneRelationship(for: "service_type")
////    }
////}

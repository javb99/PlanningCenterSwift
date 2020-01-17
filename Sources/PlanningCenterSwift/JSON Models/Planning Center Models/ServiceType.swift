//
//  ServiceType.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/11/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import JSONAPISpec

extension Models {
    public struct ServiceType {}
}
public typealias MServiceType = Resource<Models.ServiceType>

extension MServiceType {
    public init(id: MServiceType.ID,
         name: String?,
         sequenceIndex: Int,
         areAttachmentTypesEnabled: Bool? = nil,
         createdAt: Date = Date(),
         updatedAt: Date? = nil,
         archivedAt: Date? = nil,
         deletedAt: Date? = nil,
         permissions: String? = nil,
         backgroundCheckPermissions: String? = nil,
         commentPermissions: String? = nil,
         frequency: String? = nil,
         lastPlanFrom: String? = nil
    ) {
        self.init(
            identifer: id,
            attributes: .init(
                name: name,
                sequenceIndex: sequenceIndex,
                areAttachmentTypesEnabled: areAttachmentTypesEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                deletedAt: deletedAt,
                permissions: permissions,
                backgroundCheckPermissions: backgroundCheckPermissions,
                commentPermissions: commentPermissions,
                frequency: frequency,
                lastPlanFrom: lastPlanFrom
            )
        )
    }
}

extension Models.ServiceType: ResourceProtocol, SingularNameProviding {
    
    public static let singularResourceName: String = "service_type"
    
    public struct Attributes: Codable {
        
        enum CodingKeys: String, CodingKey {
            case name
            case sequenceIndex = "sequence"
            case areAttachmentTypesEnabled = "attachement_types_enabled"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case archivedAt = "archived_at"
            case deletedAt = "deleted_at"
            case permissions
            case backgroundCheckPermissions = "background_check_permissions"
            case commentPermissions = "comment_permissions"
            case frequency
            case lastPlanFrom = "last_plan_from"
        }
        
        public var name: String?
        
        public var sequenceIndex: Int
        
        public var areAttachmentTypesEnabled: Bool?
        
        public var createdAt: Date
        
        public var updatedAt: Date?
        
        public var archivedAt: Date?
        
        public var deletedAt: Date?
        
        // TODO: Add structs or enums for these types.
        
        public var permissions: String?
        
        public var backgroundCheckPermissions: String?
        
        public var commentPermissions: String?
        
        public var frequency: String?
        
        public var lastPlanFrom: String?
        
    }
    
    public struct Relationships: Codable {
        
        enum CodingKeys: String, CodingKey {
            case parent = "parent_id"
        }
        
        public var parent: ToOneRelationship<Models.Folder>?
    }
    
    public typealias Links = Empty
    
    public typealias Meta = Empty
}

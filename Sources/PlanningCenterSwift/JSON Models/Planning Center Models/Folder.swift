//
//  Folder.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/11/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import JSONAPISpec


public enum Models {}

extension Models {
    public struct Folder {
        
    }
}

extension Models.Folder: ResourceProtocol {
    
    public struct Attributes: Codable {
        
        enum CodingKeys: String, CodingKey {
            case name
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case container
        }
        
        public var name: String?
        
        public var createdAt: Date
        
        public var updatedAt: Date?
        
        public var container: String?
    }
    
    public struct Relationships: Codable {
        
        public var parent: ToOneRelationship<Models.Folder>?
        
        public var ancestors: ToManyRelationship<Models.Folder>?
    }
    
    public typealias Links = Empty
    
    public typealias Meta = Empty
}

//
//  Folder.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/11/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

public struct Folder: ResourceDecodable {
    public var id: ResourceIdentifier<Folder>
    public var name: String?
    public var parentID: ResourceIdentifier<Folder>?
    
    public init(resource: Resource) throws {
        id = try resource.identifer.specialize()
        
        name = try resource.attribute(for: "name").asString()
        parentID = resource.toOneRelationshipIfPresent(for: "parent")
    }
}

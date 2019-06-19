//
//  Person.swift
//  
//
//  Created by Joseph Van Boxtel on 6/18/19.
//

import Foundation
import GenericJSON

public struct Person: ResourceDecodable {
    
    public var id: ResourceIdentifier<Person>
    public var fullName: String
    public var photoThumbnail: URL
    
    // Relationships
    public var createdBy: ResourceIdentifier<Person>
    public var updatedBy: ResourceIdentifier<Person>
    
    
    public init(resource: Resource) throws {
        id = try resource.identifer.specialize()
        fullName = try resource.attribute(for: "full_name").asString()
        photoThumbnail = try resource.attribute(for: "photo_thumbnail_url").asURL()
        // Relationships
        createdBy = try resource.toOneRelationship(for: "created_by")
        updatedBy = try resource.toOneRelationship(for: "updated_by")
    }
}

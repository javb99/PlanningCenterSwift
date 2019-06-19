//
//  SingleResource.swift
//  
//
//  Created by Joseph Van Boxtel on 6/19/19.
//

import Foundation

/// Fetches a resource that has a path that is a collection path followed by the `id`.
public struct SingleResource<Model>: APIResourceType where Model: FetchableByIdentifier & ResourceDecodable {
    
    public let path: String
    
    public init(id: ResourceIdentifier<Model>) {
        path = Model.collectionPath + "/\(id.id)"
    }
    
    /// The initializer for alternate path initalizers.
    internal init(path: String) {
        self.path = path
    }
}

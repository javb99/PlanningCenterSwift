//
//  CountResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 4/14/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

public struct CountResource<Wrapped: APIResourceType>: APIResourceType {
    
    public typealias Model = Int
    
    /// Create a single of PCResourceDecodable objects from a JSON API document.
    public func makeModel(_ document: Document) throws -> Model {
        guard let count = document.meta?.totalCount else {
            throw ResourceDecodeError.incorrectStructure(reason: "The Document did not contain a meta field with a total count.")
        }
        return count
    }
    
    var paginatedWrapped: Paginated<Wrapped>
    
    init(wrapping: Wrapped) {
        // Force the request to return an empty data object and meta object with the total count.
        paginatedWrapped = Paginated<Wrapped>(wrapping: wrapping, pageSize: 0)
    }
    
    // MARK: Pass on to wrapped resource.
    
    public var path: String { return paginatedWrapped.path }
    public var queryItems: [URLQueryItem]? { return paginatedWrapped.queryItems }
}

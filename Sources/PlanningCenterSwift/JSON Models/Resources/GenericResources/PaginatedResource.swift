//
//  PaginatedResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 4/10/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

/// Wraps an `APIResource` to add pagination information. The model is a tuple of the wrapped model and a boolean indicating if there are more pages.
public struct Paginated<Wrapped: APIResourceType>: APIResourceType {
    public typealias Model = (Wrapped.Model, Bool)
    
    public let offset: Int
    public let pageSize: Int
    
    public let wrapped: Wrapped
    
    public init(wrapping: Wrapped, offset: Int = 0, pageSize: Int = 25) {
        wrapped = wrapping
        self.offset = offset
        self.pageSize = pageSize
    }
    
    /// Create an array of PCResourceDecodable objects from a JSON API document.
    public func makeModel(_ document: Document) throws -> Model {
        let hasAnotherPage = offset + pageSize < (document.meta?.totalCount ?? 0)
        
        return try (wrapped.makeModel(document), hasAnotherPage)
    }
    
    public var queryItems: [URLQueryItem]? {
        return paginationItems + (wrapped.queryItems ?? [])
    }
    
    public var paginationItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        items.append(.init(name: "offset", value: String(describing: offset)))
        items.append(.init(name: "per_page", value: String(describing: pageSize)))
        return items
    }
    
    public var nextPage: Paginated<Wrapped>? {
        /// Offset by the pageSize
        return Paginated<Wrapped>(wrapping: wrapped,
                                  offset: offset + pageSize,
                                  pageSize: pageSize)
    }
    
    public var path: String { return wrapped.path }
    
}

//
//  PaginatedResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 4/10/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

/// Wraps an `APIResource` to add pagination information. The model is a tuple of the wrapped model and a boolean indicating if there are more pages.
struct Paginated<Wrapped: APIResourceType>: APIResourceType {
    typealias Model = (Wrapped.Model, Bool)
    
    var offset: Int?
    var pageSize: Int?
    
    var wrapped: Wrapped
    
    init(wrapping: Wrapped) {
        wrapped = wrapping
    }
    
    /// Create an array of PCResourceDecodable objects from a JSON API document.
    func makeModel(_ document: Document) throws -> Model {
        let hasAnotherPage = (offset ?? 0) + (pageSize ?? 25) < (document.meta?.totalCount ?? 0)
        
        return try (wrapped.makeModel(document), hasAnotherPage)
    }
    
    var queryItems: [URLQueryItem]? {
        return paginationItems + (wrapped.queryItems ?? [])
    }
    
    var paginationItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let offset = offset {
            items.append(.init(name: "offset", value: String(describing: offset)))
        }
        if let pageSize = pageSize {
            items.append(.init(name: "per_page", value: String(describing: pageSize)))
        }
        return items
    }
    
    var nextPage: Paginated<Wrapped>? {
        var nextPage = Paginated<Wrapped>(wrapping: wrapped)
        /// Offset by the pageSize
        nextPage.offset = (offset ?? 0) + (pageSize ?? 25)
        return nextPage
    }
    
    var path: String { return wrapped.path }
    
}

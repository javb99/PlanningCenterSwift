//
//  FilteredEndpoint.swift
//  
//
//  Created by Joseph Van Boxtel on 10/4/19.
//

import Foundation
import JSONAPISpec

/// Wrap an endpoint with `Filtered` to provide a type that can be used to filter the endpoint.
public protocol Filterable: Endpoint {
    associatedtype Filter: QueryParamProviding
}

extension Filterable where Self: Endpoint {
    func filter(_ filter: Filter) -> AnyEndpoint<RequestBody, ResponseBody> {
        AnyEndpoint(method: self.method, path: self.path, queryParams: self.queryParams + filter.queryParams)
    }
    
    func filter(_ filters: [Filter]) -> AnyEndpoint<RequestBody, ResponseBody> {
        AnyEndpoint(method: self.method, path: self.path, queryParams: self.queryParams + filters.flatMap{$0.queryParams})
    }
}

@dynamicMemberLookup
public struct Filtered<WrappedEndpoint, Filter>: Endpoint, Filterable where
WrappedEndpoint: Endpoint, Filter: QueryParamProviding {
    
    public typealias RequestBody = WrappedEndpoint.RequestBody
    
    public typealias ResponseBody = WrappedEndpoint.ResponseBody
    
    public var method: HTTPMethod { wrapped.method }
    
    public var path: Path { wrapped.path }
    
    public var queryParams: [URLQueryItem] { wrapped.queryParams }
    
    var wrapped: WrappedEndpoint
    
    public init(_ wrapping: WrappedEndpoint, by: Filter.Type = Filter.self) {
        wrapped = wrapping
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<WrappedEndpoint, T>) -> T {
        get {
            wrapped[keyPath: keyPath]
        }
    }
}

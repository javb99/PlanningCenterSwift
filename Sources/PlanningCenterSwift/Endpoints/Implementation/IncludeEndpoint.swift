//
//  IncludeEndpoint.swift
//  
//
//  Created by Joseph Van Boxtel on 10/4/19.
//

import Foundation
import JSONAPISpec

public protocol Includable: QueryParamProviding {
    associatedtype IncludeType: Codable
}

public struct ResourceInclude<ResourceType: ResourceProtocol>: Includable {
    public typealias IncludeType = Resource<ResourceType>
    public var queryParams: [URLQueryItem] = [.init(name: "include", value: ResourceType.resourceType)]
}

public protocol PluralNameProviding {
    static var pluralResourceType: String { get }
}

public struct ResourceListInclude<ResourceType: ResourceProtocol & PluralNameProviding>: Includable {
    public typealias IncludeType = [Resource<ResourceType>]
    public var queryParams: [URLQueryItem] = [.init(name: "include", value: ResourceType.pluralResourceType)]
}

/// Adopted by endpoints to give access to the include method.
public protocol _IncludableEndpoint: Endpoint {
    // This is not actually the Include type. It is the primary resource type of the document. This is just some magic to make the compiler happy.
    associatedtype ResourceType
}

// MARK: - List Resource -

extension _IncludableEndpoint where ResponseBody == ResourceCollectionDocument<ResourceType> {
    
    /// Warning: It is undefined to include twice on one endpoint.
    // Change the include type of the response body and add the `include` query parameter.
    func include<Inc: Includable>(_ inc: Inc) -> AnyEndpoint<RequestBody, ResourceCollectionIncludesDocument<ResourceType, Inc.IncludeType>> {
        
        AnyEndpoint(method: self.method, path: self.path, queryParams: self.queryParams + inc.queryParams)
    }
    
    
    func include<Resource: ResourceProtocol>(_ inc: Resource.Type) -> AnyEndpoint<RequestBody, ResourceCollectionIncludesDocument<ResourceType, ResourceInclude<Resource>.IncludeType>> {
        
        include(ResourceInclude<Resource>())
    }
    
    func include<Resource: ResourceProtocol>(listOf inc: Resource.Type) -> AnyEndpoint<RequestBody, ResourceCollectionIncludesDocument<ResourceType, ResourceListInclude<Resource>.IncludeType>> {
        
        include(ResourceListInclude<Resource>())
    }
}

// MARK: - Individual Resource -

// TODO: Move to JSONAPISpec
public typealias ResourceIncludesDocument<Type: ResourceProtocol, Includes: Codable> = Document<Resource<Type>, Includes, Empty, Empty, Empty, Empty>

extension _IncludableEndpoint where ResponseBody == ResourceDocument<ResourceType> {
    
    /// Warning: It is undefined to include twice on one endpoint.
    // Change the include type of the response body and add the `include` query parameter.
    func include<Inc: Includable>(_ inc: Inc) -> AnyEndpoint<RequestBody, ResourceIncludesDocument<ResourceType, Inc.IncludeType>> {
        
        AnyEndpoint(method: self.method, path: self.path, queryParams: self.queryParams + inc.queryParams)
    }
    
    func include<Resource: ResourceProtocol>(_ inc: Resource.Type) -> AnyEndpoint<RequestBody, ResourceIncludesDocument<ResourceType, ResourceInclude<Resource>.IncludeType>> {
        
        include(ResourceInclude<Resource>())
    }
    
    func include<Resource: ResourceProtocol>(listOf inc: Resource.Type) -> AnyEndpoint<RequestBody, ResourceIncludesDocument<ResourceType, ResourceListInclude<Resource>.IncludeType>> {
        
        include(ResourceListInclude<Resource>())
    }
}

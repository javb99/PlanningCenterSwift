//
//  ListEndpoint.swift
//  
//
//  Created by Joseph Van Boxtel on 8/16/19.
//

import Foundation
import JSONAPISpec

public protocol SingleResourceEndpoint: Endpoint {
    associatedtype ResourceType: ResourceProtocol
    init(basePath: Path, id: ResourceIdentifier<ResourceType>)
}

extension SingleResourceEndpoint {
    public var method: HTTPMethod { .get }
}

public protocol ResourceListEndpoint: Endpoint where
    RequestBody == Empty,
    ResponseBody == ResourceCollectionDocument<ResourceType> {
    
    associatedtype InstanceEndpoint: SingleResourceEndpoint
    
    init(path: Path)
    
    subscript(id id: ResourceIdentifier<ResourceType>) -> InstanceEndpoint { get }
}

extension ResourceListEndpoint {
    
    public typealias ResourceType = InstanceEndpoint.ResourceType

    public var method: HTTPMethod { .get }
    
    public subscript(id id: ResourceIdentifier<ResourceType>) -> InstanceEndpoint {
        return InstanceEndpoint(basePath: path, id: id)
    }
}

public struct ListEndpoint<InstanceEndpoint>: ResourceListEndpoint where
InstanceEndpoint: SingleResourceEndpoint {
    
    public typealias RequestBody = Empty
    
    public typealias ResponseBody = ResourceCollectionDocument<ResourceType>
    
    public var path: Path
    public init(path: Path) {
        self.path = path
    }
}

public struct CreateEndpoint<ResourceType>: Endpoint where ResourceType: ResourceProtocol {
    
    public var method: HTTPMethod { .post }
    
    public var path: Path
    
    init(path: Path) {
        self.path = path
    }
    
    public typealias RequestBody = ResourceDocument<ResourceType>
    
    public typealias ResponseBody = ResourceDocument<ResourceType>
}

public struct CreatableListEndpoint<InstanceEndpoint>: ResourceListEndpoint where
InstanceEndpoint: SingleResourceEndpoint {
    
    public var create: CreateEndpoint<ResourceType> { .init(path: path) }
    
    // Same as ListEndpoint...
    
    public typealias RequestBody = Empty
    
    public typealias ResponseBody = ResourceCollectionDocument<ResourceType>
    
    public var path: Path
    public init(path: Path) {
        self.path = path
    }
}

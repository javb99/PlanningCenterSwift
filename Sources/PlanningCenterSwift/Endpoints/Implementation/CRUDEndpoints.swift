
import Foundation
import JSONAPISpec


public typealias CRUDEndpoint<InstanceEndpoint: SingleResourceEndpoint> = CreatableListEndpoint<Updatable<Deletable<InstanceEndpoint>>>

// MARK: - Updatable

@dynamicMemberLookup
public struct Updatable<WrappedEndpoint>: SingleResourceEndpoint where
WrappedEndpoint: SingleResourceEndpoint {
    
    public typealias WrappedResourceDoc = ResourceDocument<WrappedEndpoint.ResourceType>
    public var update: AnyEndpoint<WrappedResourceDoc, WrappedResourceDoc> { .init(method: .patch, path: path) }
    
    public typealias ResourceType = WrappedEndpoint.ResourceType
    
    public typealias RequestBody = WrappedEndpoint.RequestBody
    
    public typealias ResponseBody = WrappedEndpoint.ResponseBody
    
    public var method: HTTPMethod { wrapped.method }
    
    public var path: Path { wrapped.path }
    
    public var queryParams: [URLQueryItem] { wrapped.queryParams }
    
    var wrapped: WrappedEndpoint
    
    public init(basePath: Path, id: ResourceIdentifier<WrappedEndpoint.ResourceType>) {
        wrapped = .init(basePath: basePath, id: id)
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<WrappedEndpoint, T>) -> T {
        get {
            wrapped[keyPath: keyPath]
        }
    }
}

// MARK: - Deletable

@dynamicMemberLookup
public struct Deletable<WrappedEndpoint>: SingleResourceEndpoint where
WrappedEndpoint: SingleResourceEndpoint {
    
    public typealias WrappedResourceDoc = ResourceDocument<WrappedEndpoint.ResourceType>
    public var delete: AnyEndpoint<Empty, Empty> { .init(method: .delete, path: path) }
    
    public typealias ResourceType = WrappedEndpoint.ResourceType
    
    public typealias RequestBody = WrappedEndpoint.RequestBody
    
    public typealias ResponseBody = WrappedEndpoint.ResponseBody
    
    public var method: HTTPMethod { wrapped.method }
    
    public var path: Path { wrapped.path }
    
    public var queryParams: [URLQueryItem] { wrapped.queryParams }
    
    var wrapped: WrappedEndpoint
    
    public init(basePath: Path, id: ResourceIdentifier<WrappedEndpoint.ResourceType>) {
        wrapped = .init(basePath: basePath, id: id)
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<WrappedEndpoint, T>) -> T {
        get {
            wrapped[keyPath: keyPath]
        }
    }
}

//
//  Endpoint.swift
//
//
//  Created by Joseph Van Boxtel on 7/27/19.
//

import Foundation
import JSONAPISpec

public enum Endpoints {}

var baseURL: URL = URL(string: "https://api.planningcenteronline.com/services/v2")!

public protocol Endpoint {
    
    var method: HTTPMethod { get }
    var path: Path { get }

    associatedtype RequestBody: Encodable
    associatedtype ResponseBody: Decodable
}

extension Endpoint where RequestBody == Empty {
    var request: URLRequest {
        return URLRequest(url: URL(string: path.buildString(), relativeTo: baseURL)!)
    }
}

extension Endpoint {
    func request(with body: RequestBody) throws -> URLRequest {
        var request = URLRequest(url: URL(string: path.buildString(), relativeTo: baseURL)!)
        request.httpBody = try JSONEncoder.init().encode(body)
        return request
    }
}

public struct AnyEndpoint<RequestBody, ResponseBody>: Endpoint
where RequestBody: Encodable, ResponseBody: Decodable {
    public var method: HTTPMethod = .get
    
    public var path: Path
}

//public typealias ListEndpoint<ResourceType: ResourceProtocol> = _ListEndpoint<ResourceType, Never, Never, Never>

public struct _ListEndpoint<ResourceType, Filterables, Queryables, Orderables>: Endpoint
where ResourceType: ResourceProtocol,
Filterables: QueryParamProviding,
Queryables: QueryParamProviding,
Orderables: QueryParamProviding {

    public var method: HTTPMethod { .get }
    public typealias RequestBody = Empty
    public typealias ResponseBody = ResourceCollectionDocument<ResourceType>

    //fileprivate var include:  [URLQueryItem] = []
    fileprivate var filterBy: [URLQueryItem] = []
    fileprivate var queryBy:  [URLQueryItem] = []
    fileprivate var orderBy:  [URLQueryItem] = []

    public var path: Path

    public init(path: Path) {
        self.path = path
    }

    public init(path relativePath: Path, relativeTo parentPath: Path) {
        self.path = parentPath + relativePath
    }
    
    public init<Endpt>(path relativePath: Path, relativeTo parentEndpoint: Endpt) where Endpt: Endpoint {
        self.path = parentEndpoint.path + relativePath
    }
}

extension _ListEndpoint where Filterables: Filterable {

    public func filter(by filterable: Filterables) -> Self {
        var copy = self
        copy.filterBy.append(contentsOf: filterable.queryParams)
        return copy
    }
}
//
//extension _ListEndpoint {
//
//    /// Adds the query items to specify the include and maps the response body to include a list of the specified type.
//    public func include<I>(_ includable: I)
//        -> _ListEndpoint<ResourceType, I.ResourceType, Filterables, Queryables, Orderables>
//        where I: Includable {
//            var copy = _ListEndpoint<ResourceType, I.ResourceType, Filterables, Queryables, Orderables>(path: self.path)
//        copy.include.append(contentsOf: includable.queryParams)
//        return copy
//    }
//}

public protocol QueryParamProviding {
    var queryParams: [URLQueryItem] { get }
}

public protocol Filterable: QueryParamProviding {}

public protocol Orderable: QueryParamProviding {}

public protocol Queryable: QueryParamProviding {}

public protocol Includable: QueryParamProviding {
    associatedtype ResourceType: ResourceProtocol
}

extension Never: QueryParamProviding {
    public var queryParams: [URLQueryItem] { [] }
}
extension Empty: QueryParamProviding {
    public var queryParams: [URLQueryItem] { [] }
}
extension Array: QueryParamProviding where Element: QueryParamProviding {
    public var queryParams: [URLQueryItem] { self.flatMap{$0.queryParams} }
}

public enum HTTPMethod {
    case get
    case post
    case patch
    case delete
}

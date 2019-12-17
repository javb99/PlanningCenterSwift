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
    var queryParams: [URLQueryItem] { get }
    var requiresAuthentication: Bool { get }

    associatedtype RequestBody: Encodable
    associatedtype ResponseBody: Decodable
}

extension Endpoint {
    public var queryParams: [URLQueryItem] { [] }
    public var requiresAuthentication: Bool { true }
}

public struct AnyEndpoint<RequestBody, ResponseBody>: Endpoint
where RequestBody: Encodable, ResponseBody: Decodable {
    public var method: HTTPMethod = .get
    
    public var path: Path
    
    public var queryParams: [URLQueryItem] = []
}

public protocol QueryParamProviding {
    var queryParams: [URLQueryItem] { get }
}

public protocol Orderable: QueryParamProviding {}

public protocol Queryable: QueryParamProviding {}

extension Never: QueryParamProviding {
    public var queryParams: [URLQueryItem] { [] }
}
extension Empty: QueryParamProviding {
    public var queryParams: [URLQueryItem] { [] }
}
extension Array: QueryParamProviding where Element: QueryParamProviding {
    public var queryParams: [URLQueryItem] { self.flatMap{$0.queryParams} }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

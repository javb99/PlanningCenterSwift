//
//  JSONRequestBuilderTests.swift
//  
//
//  Created by Joseph Van Boxtel on 9/15/19.
//

import Foundation
import JSONAPISpec
import XCTest
@testable import PlanningCenterSwift

final class JSONRequestBuilderTests: XCTestCase {

    let sut = JSONRequestBuilder(baseURL: URL(string: "api.com")!, authenticationProvider: ConstantAuthProvider(), encoder: JSONEncoder())
    
    func test_buildRequest_withNoBody_encodesSuccessfully() {
        let endpoint = GenericEndpoint<Empty, Empty>(path: .init(components: ["a","simple", "path"]))
        
        let request = sut.buildRequest(for: endpoint)
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpBody, nil)
    }
    
    func test_buildRequest_withBody_encodesSuccessfully() {
        let endpoint = GenericEndpoint<[Int],Empty>(method: .post)
        
        let request = sut.buildRequest(for: endpoint, body: [1,2,3])
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpBody, try! JSONEncoder().encode([1,2,3]))
    }
    
    func test_buildRequest_httpMethod_get() {
        let getEndpoint = GenericEndpoint<Empty,Empty>(method: .get)
        XCTAssertEqual(sut.buildRequest(for: getEndpoint)?.httpMethod, HTTPMethod.get.rawValue)
    }
    
    func test_buildRequest_httpMethod_post() {
        let postEndpoint = GenericEndpoint<[Int],Empty>(method: .post)
        XCTAssertEqual(sut.buildRequest(for: postEndpoint, body: [])?.httpMethod, HTTPMethod.post.rawValue)
    }
    
    func test_buildRequest_authProvided_success() {
        let authProvider = ConstantAuthProvider(authenticationHeader: ("key", "value"))
        let sut = JSONRequestBuilder(baseURL: URL(string: "api.com")!, authenticationProvider: authProvider, encoder: JSONEncoder())
        let endpoint = GenericEndpoint<Empty,Empty>(method: .get)
        
        XCTAssertEqual(sut.buildRequest(for: endpoint)?.value(forHTTPHeaderField: "key"), "value")
    }
    
    func test_buildRequest_noAuthProvided_fails() {
        let authProvider = ConstantAuthProvider(authenticationHeader: nil)
        let sut = JSONRequestBuilder(baseURL: URL(string: "api.com")!, authenticationProvider: authProvider, encoder: JSONEncoder())
        let endpoint = GenericEndpoint<Empty,Empty>(method: .get)
        
        XCTAssertNil(sut.buildRequest(for: endpoint))
    }
}

// MARK: Helpers

struct ConstantAuthProvider: AuthenticationProvider {
    var authenticationHeader: (key: String, value: String)? = ("key", "value")
}

struct GenericEndpoint<RequestBody: Encodable, ResponseBody: Decodable>: Endpoint {
    var method: HTTPMethod = .get
    
    var path: Path = .init(components: ["a","simple", "path"])
}

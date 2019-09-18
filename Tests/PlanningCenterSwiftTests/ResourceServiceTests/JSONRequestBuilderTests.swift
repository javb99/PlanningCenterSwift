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

struct ConstantAuthProvider: AuthenticationProvider {
    var authenticationHeader: (key: String, value: String)? = ("Hello", "World")
}

struct NoBodyEndpoint: Endpoint {
    var method: HTTPMethod = .get
    
    var path: Path = .init(components: ["a","simple","path"])
    
    typealias RequestBody = Empty
    
    typealias ResponseBody = Empty
}

struct PostEndpoint: Endpoint {
    var method: HTTPMethod = .post
    
    var path: Path = .init(components: ["a","simple", "post", "path"])
    
    typealias RequestBody = [Int]
    
    typealias ResponseBody = Empty
}

final class JSONRequestBuilderTests: XCTestCase {

    func test_buildRequest_noBody() {
        let builder = JSONRequestBuilder(baseURL: URL(string: "api.com")!, authenticationProvider: ConstantAuthProvider(), encoder: JSONEncoder())
        let endpoint = NoBodyEndpoint()
        
        guard let request = builder.buildRequest(for: endpoint) else {
            XCTFail("Built a nil request")
            return
        }
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request.allHTTPHeaderFields?["Hello"], "World")
        XCTAssertEqual(request.url?.absoluteString, "api.com/a/simple/path")
        XCTAssertEqual(request.httpBody, nil)
    }
    
    func test_buildRequest_withBody() {
        let builder = JSONRequestBuilder(baseURL: URL(string: "api.com")!, authenticationProvider: ConstantAuthProvider(), encoder: JSONEncoder())
        let endpoint = PostEndpoint()
        
        guard let request = builder.buildRequest(for: endpoint, body: [1,2,3]) else {
            XCTFail("Built a nil request")
            return
        }
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
        XCTAssertEqual(request.allHTTPHeaderFields?["Hello"], "World")
        XCTAssertEqual(request.url?.absoluteString, "api.com/a/simple/post/path")
        XCTAssertEqual(request.httpBody, try! JSONEncoder().encode([1,2,3]))
    }
}


extension HTTPURLResponse {
    static var stub200: HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "api.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
}

struct ResponseEndpoint: Endpoint {
    var method: HTTPMethod = .get
    
    var path: Path = .init(components: ["a","simple", "post", "path"])
    
    typealias RequestBody = Empty
    
    typealias ResponseBody = [Int]
}

struct EmptyResponseEndpoint: Endpoint {
    var method: HTTPMethod = .get
    
    var path: Path = .init(components: ["a","simple", "post", "path"])
    
    typealias RequestBody = Empty
    
    typealias ResponseBody = Empty
}

final class JSONResponseHandlerTests: XCTestCase {
    
    let handler = JSONResponseHandler(decoder: JSONDecoder())
    let properBody = try! JSONEncoder().encode([1,2,3])

    func test_handleRequest_expectsEmpty_getsNil_success() {
        let result = handler.handleResponse(to: EmptyResponseEndpoint(), makeResponse(), data: nil, error: nil)
        XCTAssertEqual((try result.get()).2, Empty())
    }
    
    func test_handleRequest_properBody_success() {
        let result = handler.handleResponse(to: ResponseEndpoint(), makeResponse(), data: properBody, error: nil)
        XCTAssertEqual((try result.get()).2, [1,2,3])
    }
    
    func test_handleRequest_malformedBody_fails() {
        let result = handler.handleResponse(to: ResponseEndpoint(), makeResponse(), data: try! JSONEncoder().encode(["1", "2", "3"]), error: nil)
            
        XCTAssertNotNil(result.asFailure)
    }
    
    func test_handleRequest_unauthorized_fails() {
        let result = handler.handleResponse(to: ResponseEndpoint(), makeResponse(status: 401), data: properBody, error: nil)
            
        XCTAssertNotNil(result.asFailure)
    }
    
    func test_handleRequest_clientError_fails() {
        let result = handler.handleResponse(to: ResponseEndpoint(), makeResponse(status: 404), data: properBody, error: nil)
        
        XCTAssertNotNil(result.asFailure)
    }
    
    func test_handleRequest_requestFailure_failsWithSystemError() {
        let error = URLError(.dnsLookupFailed)
        let result = handler.handleResponse(to: ResponseEndpoint(), makeResponse(), data: nil, error: error)
            
        XCTAssertNotNil(result.asFailure)
    }
    
    func test_handleRequest_requestFailure_noError_fails() {
        let result = handler.handleResponse(to: ResponseEndpoint(), makeResponse(), data: nil, error: nil)
            
        XCTAssertNotNil(result.asFailure)
    }
    
    // MARK: Helpers
    
    func makeResponse(status: Int = 200) -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "api.com")!, statusCode: status, httpVersion: nil, headerFields: nil)!
    }
}

extension Result {
    var asFailure: Failure? {
        switch self {
        case let .failure(error):
            return error
        case .success(_):
            return nil
        }
    }
}


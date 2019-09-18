//
//  URLSessionService.swift
//  
//
//  Created by Joseph Van Boxtel on 6/17/19.
//

import Foundation
import JSONAPISpec

public enum NetworkError: Error {
    case noAuthorizationProvider
    case noAuthenticationHeader   // OAuth token not available.
    case notAuthorized            // Not authorized response from server.
    case noHTTPResponse
    case system(Error)
    case decode(Error)
    case unknown
}

extension NetworkError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .noAuthenticationHeader:
            return "No authenticationHeader provided."
        case .noAuthorizationProvider:
            return "No AuthenticationProvider supplied to URLSessionService."
        case .notAuthorized:
            return "Not authorized."
        case .noHTTPResponse:
            return "URLResponse is not an HTTPURLResposne"
        case let .system(e):
            return "System error: \(e)"
        case let .decode(e):
            return "Decode error: \(e)"
        case .unknown:
            return "Unkown Networking error."
        }
    }
}

public class URLSessionService {
    
    public let session: URLSession
    
    public let requestBuilder: RequestBuilder
    
    public let responseHandler: ResponseHandler
    
    public init(requestBuilder: RequestBuilder, responseHandler: ResponseHandler, session: URLSession) {
        self.requestBuilder = requestBuilder
        self.session = session
        self.responseHandler = responseHandler
    }
    
    public typealias Completion<Endpt: Endpoint> = (Result<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError>) -> ()
    
    
    // MARK: Interface
    
    
    /// Execute a request for an endpoint that doesn't require a request body.
    public func fetch<Endpt: Endpoint>(_ endpoint: Endpt, completion: @escaping Completion<Endpt>) where Endpt.RequestBody == Empty {
        
        guard let request = requestBuilder.buildRequest(for: endpoint) else {
            fatalError("Failed to build request.")
        }
        send(request, for: endpoint, completion: completion)
    }
    
    /// Execute a request for an endpoint that requires a request body.
    public func send<Endpt: Endpoint>(body: Endpt.RequestBody, to endpoint: Endpt, completion: @escaping Completion<Endpt>) {
        
        guard let request = requestBuilder.buildRequest(for: endpoint, body: body) else {
            fatalError("Failed to build request.")
        }
        send(request, for: endpoint, completion: completion)
    }
    
    
    // MARK: Implementation
    
    
    private func send<Endpt>(_ request: URLRequest, for endpoint: Endpt, completion: @escaping Completion<Endpt>) where Endpt: Endpoint {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let result = self.responseHandler.handleResponse(to: endpoint, response, data: data, error: error)
            completion(result)
        }
        task.resume()
    }
}

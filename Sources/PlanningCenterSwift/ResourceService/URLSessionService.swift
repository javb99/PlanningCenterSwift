//
//  URLSessionService.swift
//  
//
//  Created by Joseph Van Boxtel on 6/17/19.
//

import Foundation
import JSONAPISpec

public class URLSessionService: PCOService {
    
    public let session: URLSession
    
    public let requestBuilder: RequestBuilder
    
    public let responseHandler: ResponseHandler
    
    public init(requestBuilder: RequestBuilder, responseHandler: ResponseHandler, session: URLSession) {
        self.requestBuilder = requestBuilder
        self.session = session
        self.responseHandler = responseHandler
    }
    
    
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

extension URLSessionService {
    
    public convenience init(authenticationProvider: BasicAuthenticationProvider) {
        let baseURL = URL(string: "https://api.planningcenteronline.com/services/v2/")!
        
        self.init(
            requestBuilder: JSONRequestBuilder(
                baseURL: baseURL,
                authenticationProvider: authenticationProvider,
                encoder: JSONEncoder.pco
            ),
            responseHandler: JSONResponseHandler(
                decoder: JSONDecoder.pco
            ),
            session: .shared
        )
    }
}

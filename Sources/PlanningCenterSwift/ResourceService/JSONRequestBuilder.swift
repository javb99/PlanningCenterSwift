//
//  JSONRequestBuilder.swift
//  
//
//  Created by Joseph Van Boxtel on 9/15/19.
//

import Foundation
import JSONAPISpec

public class JSONRequestBuilder: RequestBuilder {
    
    let baseURL: URL
    
    let authenticationProvider: AuthenticationProvider
    
    let encoder: JSONEncoder
    
    public init(baseURL: URL, authenticationProvider: AuthenticationProvider, encoder: JSONEncoder) {
        self.baseURL = baseURL
        self.authenticationProvider = authenticationProvider
        self.encoder = encoder
    }
    
    public func buildRequest<Endpt: Endpoint>(for endpoint: Endpt) -> URLRequest?
        where Endpt.RequestBody == Empty {
        
        return buildRequest(for: endpoint, body: nil)
    }
    
    public func buildRequest<Endpt: Endpoint>(for endpoint: Endpt, body: Endpt.RequestBody) -> URLRequest? {
        
        guard let bodyData = try? encoder.encode(body) else {
            return nil
        }
        return buildRequest(for: endpoint, body: bodyData)
    }
    
    private func buildRequest<Endpt: Endpoint>(for endpoint: Endpt, body: Data?) -> URLRequest? {
        
        let url = endpoint.path.components.reduce(baseURL) { (url, component) -> URL in
            url.appendingPathComponent(component, isDirectory: false)
        }
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        comps?.queryItems = endpoint.queryParams
        guard let fullURL = comps?.url else { return nil }
        
        var request = URLRequest(url: fullURL)
        request.httpBody = body
        request.httpMethod = endpoint.method.rawValue
        
        // Add the authentication header.
        guard let (headerField, value) = authenticationProvider.authenticationHeader else {
            return nil
        }
        request.addValue(value, forHTTPHeaderField: headerField)
        
        return request
    }
}

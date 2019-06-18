//
//  URLSessionService.swift
//  
//
//  Created by Joseph Van Boxtel on 6/17/19.
//

import Foundation
import Combine

enum NetworkError: Error {
    case noAuthorizationProvider
    case noAuthenticationHeader   // OAuth token not available.
    case notAuthorized            // Not authorized response from server.
}

extension NetworkError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .noAuthenticationHeader:
            return "No authenticationHeader provided."
        case .noAuthorizationProvider:
            return "No AuthenticationProvider supplied to URLSessionService."
        case .notAuthorized:
            return "Not authorized."
        }
    }
}

public class URLSessionService: ResourceService {
    
    public var session: URLSession = .shared
    
    public var authenticationProvider: AuthenticationProvider? = nil
    
    public func fetch<Resource>(resource: Resource, completion: @escaping (Resource, Result<Resource.Model, Error>) -> ()) where Resource : NetworkResourceType {
        
        var request = resource.urlRequest
        
        // Add the authentication header.
        if Resource.requiresAuthentication {
            guard let provider = authenticationProvider else {
                completion(resource, .failure(NetworkError.noAuthorizationProvider))
                return
            }
            guard let (headerField, value) = provider.authenticationHeader else {
                completion(resource, .failure(NetworkError.noAuthenticationHeader))
                return
            }
            request.addValue(value, forHTTPHeaderField: headerField)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if (response as? HTTPURLResponse)?.statusCode == 401 {
                completion(resource, .failure(NetworkError.notAuthorized))
            } else if let data = data {
                let result = Result<Resource.Model, Error>(){
                    // Capture any errors in the result.
                    return try resource.makeModel(data)
                }
                completion(resource, result)
                
            } else if let error = error {
                completion(resource, .failure(error))
            } else {
                assertionFailure()
            }
        }
        task.resume()
    }
}

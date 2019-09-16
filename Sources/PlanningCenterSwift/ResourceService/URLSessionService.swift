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
    case noHTTPResponse
    case system(Error)
    case decode(Error)
    case unknown
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
    
    public var session: URLSession = .shared
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()
    
    public var authenticationProvider: AuthenticationProvider? = nil
    
    public init(session: URLSession = .shared, authenticationProvider: AuthenticationProvider? = nil) {
        self.authenticationProvider = authenticationProvider
        self.session = session
    }
    
    public func fetch<Endpt>(_ endpoint: Endpt) where Endpt: Endpoint {
        
    }
    
    public func send<Endpt>(body: Endpt.RequestBody, to: Endpt) where Endpt: Endpoint {
        
    }
    
    private func send<Endpt>(request: URLRequest, for endpoint: Endpt, completion: @escaping (Result<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError>) -> ()) where Endpt: Endpoint {
        
        var request = request
        
        // Add the authentication header.
        guard let provider = authenticationProvider else {
            completion(.failure(.noAuthorizationProvider))
            return
        }
        guard let (headerField, value) = provider.authenticationHeader else {
            completion(.failure(.noAuthenticationHeader))
            return
        }
        request.addValue(value, forHTTPHeaderField: headerField)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let result = self.handleResponse(to: endpoint, response, data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func handleResponse<Endpt: Endpoint>(to endpoint: Endpt, _ response: URLResponse?, data: Data?, error: Error?)
        -> Result<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError> {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noHTTPResponse)
        }
        
        guard httpResponse.statusCode != 401 else {
            return .failure(.notAuthorized)
        }
        
        guard let data = data else {
            if let error = error {
                return .failure(.system(error))
            } else {
                return .failure(.unknown)
            }
        }
        
        let model: Endpt.ResponseBody
        do {
            model = try decoder.decode(Endpt.ResponseBody.self, from: data)
        } catch {
            return .failure(.decode(error))
        }
        
        return .success((httpResponse, endpoint, model))
    }
}

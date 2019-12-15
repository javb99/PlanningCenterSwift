//
//  NetworkError.swift
//  
//
//  Created by Joseph Van Boxtel on 9/18/19.
//

import Foundation
import JSONAPISpec

public enum NetworkError: Error {
    case noAuthorizationProvider
    case noAuthenticationHeader   // OAuth token not available.
    case notAuthorized            // Not authorized response from server.
    case noHTTPResponse
    case rateLimit
    case client(Int)
    case server(Int)
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
        case .rateLimit:
            return "Hit the rate limit"
        case .notAuthorized:
            return "Not authorized."
        case .noHTTPResponse:
            return "URLResponse is not an HTTPURLResposne"
        case let .client(code):
            return "Client error. Code \(code)"
        case let .server(code):
            return "Server error. Code \(code)"
        case let .system(e):
            return "System error: \(e)"
        case let .decode(e):
            return "Decode error: \(e)"
        case .unknown:
            return "Unkown Networking error."
        }
    }
}

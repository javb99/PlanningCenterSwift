//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/17/19.
//

import Foundation

public protocol NetworkResourceType: ResourceType {
    
    /// The location of the resource.
    var url: URL { get }
    
    /// Provide a request value to fetch this resource.
    /// Default Implementation: Construct a basic `URLRequest` using `url`
    var urlRequest: URLRequest { get }
    
    /// Whether the `authenticationProvider` should be asked for an authorization header.
    /// Default implementation returns `false`.
    static var requiresAuthentication: Bool { get }
    
    /// The provider of the authorization header.
    /// Default implemenation provided just returns `nil`.
    //static var authenticationProvider: AuthenticationProvider? { get }
}

extension NetworkResourceType {
    
    public var urlRequest: URLRequest {
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
    
    public static var requiresAuthentication: Bool {
        return false
    }
    
//    public static var authenticationHeader: AuthenticationProvider? {
//        return nil
//    }
}

public typealias JSONNetworkResourceType = NetworkResourceType & JSONResourceType

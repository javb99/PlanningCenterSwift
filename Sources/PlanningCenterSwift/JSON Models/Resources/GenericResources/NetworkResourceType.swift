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
    
    static var requiresAuthentication: Bool { get }
    var authenticationHeader: (key: String, value: String)? { get }
}

extension NetworkResourceType {
    
    var urlRequest: URLRequest {
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
    
    static var requiresAuthentication: Bool {
        return false
    }
    
    public var authenticationHeader: (key: String, value: String)? {
        return nil
    }
}

public typealias JSONNetworkResourceType = NetworkResourceType & JSONResourceType

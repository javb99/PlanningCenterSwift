//
//  PlanningCenterResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/7/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import GenericJSON

/// Defines a Planning Center resouce. Rather that defining location using a `URL` now use a path string relative to the base `URL`.
public protocol APIResourceType: JSONNetworkResourceType {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    func makeModel(_ document: Document) throws -> Model
}

/// The url of the Planing Center Services api.
var baseURL = URL(string: "https://api.planningcenteronline.com/services/v2/")!

extension APIResourceType {
    
    public var url: URL {
        var components = URLComponents()
        components.path = path
        components.queryItems = queryItems
        guard let result = components.url(relativeTo: baseURL) else {
            fatalError("Failed to generate URL for path: \(path) and queryItems: \(String(describing: queryItems))")
        }
        return result
    }
    
    public var queryItems: [URLQueryItem]? {
        return nil
    }
    
    public func makeModel(_ json: JSON) throws -> Model {
        return try makeModel(try Document(json: json))
    }
    
    public static var requiresAuthentication: Bool {
        return true
    }
    
//    var authenticationHeader: (key: String, value: String)? {
//        guard Self.requiresAuthentication, let credential = OAuthManager.shared.authenticationHeaderCredential else {
//            return nil
//        }
    //        return (keypublic : "Authorization", value:public  credential)
    // public    }
    
    public var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        return urlRequest
    }
}

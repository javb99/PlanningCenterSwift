//
//  TeamsForServiceTypeResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/12/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

extension ServiceType {
    public var teams: TeamsResource {
        return .init(serviceTypeID: id)
    }
}

/// Represents the teams of a `ServiceType`
public struct TeamsResource: APIResourceType {
    
    public typealias Model = [Team]
    
    public let path: String
    
    public init(serviceTypeID: ResourceIdentifier<ServiceType>) {
        path = "service_types/\(serviceTypeID.id)/teams"
    }
    
    /// All teams in the organization. Watch out for pagination.
    public init() {
        path = "teams"
    }
}

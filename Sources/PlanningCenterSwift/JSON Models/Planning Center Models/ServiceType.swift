//
//  ServiceType.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/11/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

//struct ServiceType: PCResourceDecodable {
//    let id: String
//    let name: String
//
//    init(id: String, name: String) {
//        self.id = id
//        self.name = name
//    }
//
//    init(resource: Resource) throws {
//        assert(resource.type == "ServiceType", "Resource is not the correct type.")
//        id = resource.id
//        name = try resource.attribute(for: "name").asString()
//    }
//}

public struct ServiceType: ResourceDecodable {
    
    public var id: ResourceIdentifier<ServiceType>
    
    /// The name of the service type as seen by the user.
    public var name: String
    
    public init(id: String, name: String) {
        self.id = ResourceIdentifier<ServiceType>(id: id)
        self.name = name
    }
}

extension ServiceType {

    public init(resource: Resource) throws {
        id = try resource.identifer.specialize()
        name = try resource.attribute(for: "name").asString()
    }
}

//
//  TeamEndpoint.swift
//  
//
//  Created by Joseph Van Boxtel on 10/4/19.
//

import Foundation
import JSONAPISpec

// MARK: - Team Specific -

extension Endpoints.Team {
    public var withServiceType: some Endpoint {
        // Only actually one.
        self.include(Models.ServiceType.self)
    }
}

// MARK: - Boilerplate -

extension Endpoints.ServicesOrganizationEndpoint {
    
    public var teams: CRUDEndpoint<Endpoints.Team> { .init(path: path.appending("teams")) }
}

extension Endpoints {
    
    public struct Team: SingleResourceEndpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.Team>
        
        public typealias ResourceType = Models.Team
        
        public var path: Path

        public init(basePath: Path, id: ResourceIdentifier<Models.Team>) {
            path = basePath.appending(id.id)
        }
    }
}

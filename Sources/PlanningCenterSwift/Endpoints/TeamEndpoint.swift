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
    
}

// MARK: - Boilerplate -

extension Endpoints {
    
    public static var teams = CRUDEndpoint<Team>(path: ["team"])

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
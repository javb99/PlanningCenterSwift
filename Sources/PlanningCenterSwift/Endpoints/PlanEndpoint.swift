//
//  PlanEndpoint.swift
//  
//
//  Created by Joseph Van Boxtel on 10/4/19.
//

import Foundation
import JSONAPISpec

// MARK: - Plan Specific -

extension Endpoints.Plan {
    public var teamMembers: CreatableListEndpoint<Endpoints.PlanPerson> { .init(path: path.appending("team_members")) }
}

// MARK: - Boilerplate -

extension Endpoints.ServicesOrganizationEndpoint {
    
    public var plans: CRUDEndpoint<Endpoints.Plan> { .init(path: path.appending("plans")) }
}

extension Endpoints {
    
    public struct Plan: SingleResourceEndpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.Plan>
        
        public typealias ResourceType = Models.Plan
        
        public var path: Path

        public init(basePath: Path, id: ResourceIdentifier<Models.Plan>) {
            path = basePath.appending(id.id)
        }
    }
}

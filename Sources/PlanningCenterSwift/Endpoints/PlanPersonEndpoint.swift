//
//  PlanPersonEndpoint.swift
//  
//
//  Created by Joseph Van Boxtel on 10/4/19.
//

import Foundation
import JSONAPISpec

extension Endpoints.ServicesOrganizationEndpoint {
    
    public var planPeople: ListEndpoint<Updatable<Deletable<Endpoints.PlanPerson>>> { .init(path: path.appending("plan_people")) }
}

extension Endpoints {
    
    public struct PlanPerson: SingleResourceEndpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.PlanPerson>
        
        public typealias ResourceType = Models.PlanPerson
        
        public var path: Path

        public init(basePath: Path, id: ResourceIdentifier<Models.PlanPerson>) {
            path = basePath.appending(id.id)
        }
    }
}

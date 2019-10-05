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
    
}

// MARK: - Boilerplate -

extension Endpoints {
    
    public static var plans = CRUDEndpoint<Folder>(path: ["plans"])

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
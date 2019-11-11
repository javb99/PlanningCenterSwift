//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 11/10/19.
//

import Foundation
import JSONAPISpec

extension Endpoints {
    public static var people = PeopleOrganizationEndpoint()

    public struct PeopleOrganizationEndpoint: Endpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.Organization>
        
        public typealias ResourceType = Models.Organization
        
        public var path: Path = ["people", "v2"]
    }
}

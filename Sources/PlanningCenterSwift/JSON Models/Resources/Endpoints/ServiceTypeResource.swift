//
//  ServiceTypeResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 4/1/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

struct ServiceTypeResource: APIResourceType {
    
    typealias Model = ServiceType
    
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    var path: String {
        return "service_types/\(id)"
    }
}

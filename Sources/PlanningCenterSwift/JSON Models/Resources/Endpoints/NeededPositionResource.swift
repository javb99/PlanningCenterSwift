//
//  NeededPositionRequest.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/5/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

extension Plan {
    /// The configured resource to fetch this plan's needed positions.
    var neededPositions: NeededPositionsResource {
        return NeededPositionsResource(serviceType: serviceTypeID, plan: id)
    }
}

struct NeededPositionsResource: APIResourceType {
    
    typealias Model = [NeededPosition]
    
    var serviceType: ResourceIdentifier<ServiceType>
    var plan: ResourceIdentifier<Plan>
    
    var path: String {
        return "service_types/\(serviceType.id)/plans/\(plan.id)/needed_positions"
    }
    
    public init(serviceType: ResourceIdentifier<ServiceType>, plan: ResourceIdentifier<Plan>) {
        self.serviceType = serviceType
        self.plan = plan
    }
}

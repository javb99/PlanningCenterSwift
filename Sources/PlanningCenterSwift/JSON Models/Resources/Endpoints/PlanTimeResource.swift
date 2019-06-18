//
//  PlanTimeResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/11/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import GenericJSON

extension Plan {
    /// A configured resource to fetch the plan times for this plan.
    var timesResource: PlanTimesResource {
        return PlanTimesResource(serviceTypeID: serviceTypeID, planID: id)
    }
}

struct PlanTimesResource: APIResourceType {
    
    typealias Model = [PlanTime]
    
    var serviceTypeID: ResourceIdentifier<ServiceType>
    var planID: ResourceIdentifier<Plan>
    
    var path: String {
        return "service_types/\(serviceTypeID.id)/plans/\(planID.id)/plan_times"
    }
    
    public init(serviceTypeID: ResourceIdentifier<ServiceType>, planID: ResourceIdentifier<Plan>) {
        self.serviceTypeID = serviceTypeID
        self.planID = planID
    }
}

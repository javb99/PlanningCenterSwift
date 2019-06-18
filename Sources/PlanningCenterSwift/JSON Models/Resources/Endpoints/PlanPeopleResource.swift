//
//  PlanPeopleResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 3/30/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import GenericJSON

extension Plan {
    /// A configured resource to fetch the `PlanPeople` for this `Plan`.
    var planPeople: PlanPeopleResource {
        return PlanPeopleResource(serviceTypeID: serviceTypeID, planID: id)
    }
}

struct PlanPeopleResource: APIResourceType {
    typealias Model = [PlanPerson]

    var serviceTypeID: ResourceIdentifier<ServiceType>
    var planID: ResourceIdentifier<Plan>

    var path: String {
        return "service_types/\(serviceTypeID)/plans/\(planID)/team_members"
    }

    public init(serviceTypeID: ResourceIdentifier<ServiceType>, planID: ResourceIdentifier<Plan>) {
        self.serviceTypeID = serviceTypeID
        self.planID = planID
    }
}

//
//  PlanRequest.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/5/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import GenericJSON

extension ServiceType {
    public var futurePlans: PlansResource {
        return .init(serviceType: id)
    }
}

extension Team {
    public var futurePlans: PlansResource {
        return .init(serviceType: serviceTypeID)
    }
}

/// Fetch the plans including their `PlanTime`s.
public struct PlansResource: APIResourceType {
    
    public typealias Model = [Plan]
    
    public var serviceType: ResourceIdentifier<ServiceType>
    public var shouldIncludePastPlans: Bool
    
    public var path: String {
        return "service_types/\(serviceType.id)/plans"
    }
    
    public var queryItems: [URLQueryItem]? {
        var results = [URLQueryItem]()
        results.append(URLQueryItem(name: "include", value: "plan_times"))
        if !shouldIncludePastPlans {
            results.append(URLQueryItem(name: "filter", value: "future"))
        }
        return results
    }
    
    public init(serviceType: ResourceIdentifier<ServiceType>, pastPlans: Bool = false) {
        self.serviceType = serviceType
        self.shouldIncludePastPlans = pastPlans
    }
    
    public func makeModel(_ document: Document) throws -> [Plan] {
        guard let plans = try document.data?.asMultiple?.compactMap(Plan.init(resource:)), let times = try document.included?.compactMap(PlanTime.init) else {
            // Only for the nil case which comes from the document structure not being what is expected.
            throw ResourceDecodeError.incorrectStructure(reason: "Missing data array or included times.")
        }
        let timesIDMap = Dictionary<ResourceIdentifier<PlanTime>, PlanTime>(sequence: times, keyMapper: {$0.id})
        return plans.map { plan in
            // Fill the plan with the time objects.
            var filledPlan = plan
            filledPlan.times = timesIDMap
            return filledPlan
        }
    }
}

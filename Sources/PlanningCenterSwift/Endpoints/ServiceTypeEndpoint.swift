//
//  ServiceTypeEndpoint.swift
//  
//
//  Created by Joseph Van Boxtel on 8/16/19.
//

import Foundation
import JSONAPISpec

extension Endpoints {

    public static var serviceTypes = CRUDEndpoint<ServiceType>(path: ["service_types"])

    public struct ServiceType: SingleResourceEndpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.ServiceType>
        
        public typealias ResourceType = Models.ServiceType

        public var path: Path

        public init(basePath: Path, id: ResourceIdentifier<Models.ServiceType>) {
            path = basePath.appending(id.id)
        }

//        public var plans: Plans { Plans(path: path + "/plans") }
//
//        public var unscopedPlans: Plans { Plans(path: path + "/unscoped_plans") }
//
//        public var planTimes: PlanTimes { PlanTimes(path: path + "/plan_times") }
//
//        public var teams: Teams { Teams(path: path + "/plans") }

    //    public var teamPositions: AnyCodableNetworkTransaction<Empty, ResourceCollectionDocument<TeamPosition>> {
    //        return .init(path: instancePath + "/team_positions")
    //    }
    //
    //    public var planNoteCategories: AnyCodableNetworkTransaction<Empty, ResourceCollectionDocument<TeamPosition>> {
    //        return .init(path: instancePath + "/plan_note_categories")
    //    }
    //
    //    public var attachments: AnyCodableNetworkTransaction<Empty, ResourceCollectionDocument<Attachment>> {
    //        return .init(path: instancePath + "/attachments")
    //    }

    //    public func createPlans(starting startDate: Date, basedOn templateID: ResourceIdentifier<Plan>, copyItems: Bool = true, copyNotes: Bool = true, copyItems: true) -> AnyCodableNetworkTransaction<..., ResourceCollectionDocument<Folder>> {
    //        ...
    //    }
    }
}

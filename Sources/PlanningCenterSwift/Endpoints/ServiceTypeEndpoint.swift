//
//  ServiceTypeEndpoint.swift
//  
//
//  Created by Joseph Van Boxtel on 8/16/19.
//

import Foundation
import JSONAPISpec

// MARK: - ServiceType Specific -

extension Endpoints.ServiceType {
    public var plans: Filtered<ListEndpoint<Endpoints.Plan>, PlanFilter> {
        Filtered(ListEndpoint<Endpoints.Plan>(path: path.appending("plans")))
    }
    
    public var teams: ListEndpoint<Endpoints.Team> {
        ListEndpoint<Endpoints.Team>(path: path.appending("teams"))
    }
}

extension Endpoints.ServiceType {
    public enum PlanFilter {
        case after(Date)
        case before(Date)
        case future
        case noDates
        case past
    }
}

extension Endpoints.ServiceType.PlanFilter: QueryParamProviding {
    public var queryParams: [URLQueryItem] {
        switch self {
        case .noDates:
            return [URLQueryItem(name: "filter", value: "no_dates")]
        case let .before(date):
            let stringRep = pcjsonDateAndTimeFormatter.string(from: date)
            return [URLQueryItem(name: "filter[after]", value: stringRep)]
        case let .after(date):
            let stringRep = pcjsonDateAndTimeFormatter.string(from: date)
            return [URLQueryItem(name: "filter[after]", value: stringRep)]
        case .future:
            return [URLQueryItem(name: "filter", value: "future")]
        case .past:
            return [URLQueryItem(name: "filter", value: "past")]
        }
    }
}

// MARK: - Boilerplate -

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

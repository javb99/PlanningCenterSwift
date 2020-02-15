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
    public struct PlanFilter {
        
        public var lowerBound: Date?
        public var upperBound: Date?
        
        public static let noDates = Self(lowerBound: nil, upperBound: nil)
        public static let future = Self(lowerBound: Date(), upperBound: nil)
        public static let past = Self(lowerBound: nil, upperBound: Date())
        
        public static func between(_ lowerBound: Date, and upperBound: Date) -> Self {
            Self(lowerBound: lowerBound, upperBound: upperBound)
        }
    }
}

extension Endpoints.ServiceType.PlanFilter: QueryParamProviding {
    
    public var queryParams: [URLQueryItem] {
        switch (lowerBound, upperBound) {
        case (.none, .none):
            return [URLQueryItem(name: "filter", value: "no_dates")]
        case (let .some(l), let .some(u)):
            return [
                URLQueryItem(name: "filter", value: "after,before"),
                URLQueryItem(name: "before", value: pcjsonDateAndTimeFormatter.string(from: u)),
                URLQueryItem(name: "after", value: pcjsonDateAndTimeFormatter.string(from: l))
            ]
        case (.none, let .some(u)):
            return [
                URLQueryItem(name: "filter", value: "before"),
                URLQueryItem(name: "before", value: pcjsonDateAndTimeFormatter.string(from: u))
            ]
        case (let .some(l), .none):
            return [
                URLQueryItem(name: "filter", value: "after"),
                URLQueryItem(name: "after", value: pcjsonDateAndTimeFormatter.string(from: l))
            ]
        }
    }
}

extension Endpoints.ServicesOrganizationEndpoint {
    
    public var serviceTypes: Filtered<CRUDEndpoint<Endpoints.ServiceType>, Endpoints.Folder.ParentFilter> { Filtered(.init(path: path.appending("service_types"))) }
    
    public var rootServiceTypes: AnyEndpoint<Empty, ResourceCollectionDocument<Models.ServiceType>> { serviceTypes.filter(.root) }
}

extension Endpoints {

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

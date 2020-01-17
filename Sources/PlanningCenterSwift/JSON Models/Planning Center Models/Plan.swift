//
//  Plan.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/5/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import JSONAPISpec

extension Models {
    public struct Plan {}
}
public typealias MPlan = Resource<Models.Plan>

extension MPlan {
    public init(
        id: MPlan.ID,
        title: String? = nil,
        seriesTitle: String? = nil,
        itemsCount: Int,
        planNotesCount: Int,
        planPeopleCount: Int,
        neededPositionsCount: Int,
        serviceTimeCount: Int,
        rehearsalTimeCount: Int,
        otherTimeCount: Int,
        createdAt: Date = Date(),
        updatedAt: Date? = nil,
        filesExpireAt: Date? = nil,
        sortDate: Date? = nil,
        lastTimeAt: Date? = nil,
        isMultiDay: Bool? = nil,
        shortDates: String? = nil,
        longDates: String? = nil,
        totalLength: Int,
        myPermissionsFor: String? = nil,
        isPublic: Bool? = nil
    ) {
        self.init(
            identifer: id,
            attributes: .init(
                title: title,
                seriesTitle: seriesTitle,
                itemsCount: itemsCount,
                planNotesCount: planNotesCount,
                planPeopleCount: planPeopleCount,
                neededPositionsCount: neededPositionsCount,
                serviceTimeCount: serviceTimeCount,
                rehearsalTimeCount: rehearsalTimeCount,
                otherTimeCount: otherTimeCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                filesExpireAt: filesExpireAt,
                sortDate: sortDate,
                lastTimeAt: lastTimeAt,
                isMultiDay: isMultiDay,
                shortDates: shortDates,
                longDates: longDates,
                totalLength: totalLength,
                myPermissionsFor: myPermissionsFor,
                isPublic: isPublic
            )
        )
    }
}

extension Models.Plan: ResourceProtocol {

    public struct Attributes: Codable {

        enum CodingKeys: String, CodingKey {
            case title
            case seriesTitle = "series_title"

            case itemsCount = "items_count"
            case planNotesCount = "plan_notes_count"
            case planPeopleCount = "plan_people_count"
            case neededPositionsCount = "needed_positions_count"
            case serviceTimeCount = "service_time_count"
            case rehearsalTimeCount = "rehearsal_time_count"
            case otherTimeCount = "other_time_count"

            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case filesExpireAt = "files_expire_at"
            case sortDate = "sort_date"
            case lastTimeAt = "last_time_at"
            case isMultiDay = "multi_day"
            case shortDates = "short_dates"
            case longDates = "dates"
            case totalLength = "total_length"

            case myPermissionsFor = "permissions"
            case isPublic = "public"
        }

        public var title: String?

        public var seriesTitle: String?

        public var itemsCount: Int

        public var planNotesCount: Int

        /// I don't think this double counts people in two positions.
        public var planPeopleCount: Int

        public var neededPositionsCount: Int

        public var serviceTimeCount: Int

        public var rehearsalTimeCount: Int

        public var otherTimeCount: Int

        public var createdAt: Date?

        public var updatedAt: Date?

        public var filesExpireAt: Date?

        /// A  date (though, time is not necessarily a service time) to sort plans by.
        public var sortDate: Date?

        public var lastTimeAt: Date?

        public var isMultiDay: Bool?

        /// The short form of the service dates. Ex. "Jun 26 & 27"
        public var shortDates: String?

        /// The long form of the service dates. Ex. "June 26 & 27, 2019"
        public var longDates: String?

        /// Number of minutes the service takes (Unkown if it includes pre/post service).
        public var totalLength: Int // TODO: Time Interval

        /// Permissions of the current user for this plan.
        public var myPermissionsFor: String? // Use a specific model

        public var isPublic: Bool?
    }

    public struct Relationships: Codable {

        enum CodingKeys: String, CodingKey {
            case serviceType = "service_type"
            case nextPlan = "next_plan"
            case prevPlan = "previous_plan"
//            case attachmentTypes = "attachment_types"
//            case series
            case createdBy = "created_by"
            case updatedBy = "updated_by"
        }

        /// The containing service type.
        public var serviceType: ToOneRelationship<Models.ServiceType>?

        /// The next plan in the service types.
        public var nextPlan: ToOneRelationship<Models.Plan>?

        /// The preceding plan in the service type.
        public var prevPlan: ToOneRelationship<Models.Plan>?

//        public var attachmentTypes: ToManyRelationship<[AttachmentType]>?
//        public var series: ToOneRelationship<Series>?
//
        public var createdBy: ToOneRelationship<Models.Person>

        /// The person to most recently update the plan.
        public var updatedBy: ToOneRelationship<Models.Person>?
    }

    public typealias Links = Empty
    public typealias Meta = Empty
}

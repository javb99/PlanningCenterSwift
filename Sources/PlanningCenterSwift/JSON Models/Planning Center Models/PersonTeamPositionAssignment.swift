//
//  Created by Joseph Van Boxtel on 11/10/19.
//

import Foundation
import JSONAPISpec

extension Models {
    /// [Planning Center Documentation](https://developer.planning.center/docs/#/apps/services/2018-11-01/vertices/person_team_position_assignment)
    public struct PersonTeamPositionAssignment {}
}

extension Models.PersonTeamPositionAssignment: ResourceProtocol {

    public struct Attributes: Codable {

        enum CodingKeys: String, CodingKey {
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case schedulePreference = "schedule_preference"
            case preferredWeeks = "preferred_weeks"
        }
        
        public var createdAt: Date

        public var updatedAt: Date?

        public var schedulePreference: SchedulePreference
        public enum SchedulePreference: String, Codable {
            case everyWeek = "Every week"
            case everyOtherWeek = "Every other week"
            case everyThirdWeek = "Every 3rd week"
            case everyFourthWeek = "Every 4th week"
            case everyFifthWeek = "Every 5th week"
            case everySixWeek = "Every 6th week"
            case oncePerMonth = "Once a month"
            case twicePerMonth = "Twice a month"
            case threePerMonth = "Three times a month"
            case chooseWeeks = "Choose Weeks"
        }
        
        /// When schedule_preference is set to "Choose Weeks" then this indicates which weeks are preferred (checked).
        /// e.g. '1', '3', '5' to prefer odd numbered weeks.
        public var preferredWeeks: [Int]
    }

    public struct Relationships: Codable {

        enum CodingKeys: String, CodingKey {
            case person
            //case teamPosition = "team_position"
            //case timePreferenceOptions = "time_preference_options"
        }

        public var person: ToOneRelationship<Models.Person>

        //public var teamPosition: ToOneRelationship<Models.TeamPosition>
        
        //public var timePreferenceOptions: ToManyRelationship<Models.TimePreferenceOption>
    }

    public typealias Links = Empty

    public typealias Meta = Empty
}

//
//  Created by Joseph Van Boxtel on 11/11/19.
//

import Foundation
import JSONAPISpec

extension Models {
    public struct PeoplePerson {}
}

extension Models.PeoplePerson: ResourceProtocol {
    
    public static var resourceType: String = "Person"

    public struct Attributes: Codable {

        // MARK: Name Fields

        public var firstName: String?

        public var lastName: String?

        public var givenName: String?

        public var middleName: String?

        public var name: String?

        public var nickname: String?

        // MARK: Date Fields
        
        public var createdAt: Date?

        public var updatedAt: Date?

        public var anniversary: Date?

        public var birthdate: String? // Month-day-year
        
        // MARK: Other Fields

        public var avatar: URL?

        public var permissions: String? // Model this?

        public var isSiteAdmin: Bool?

        public var hasPassedBackgroundCheck: Bool?

        public var status: String // TODO: Use an enum?
        
        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case lastName = "last_name"
            case givenName = "given_name"
            case middleName = "middle_name"
            case name
            case nickname

            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case anniversary
            case birthdate

            case avatar
            case permissions = "people_permissions"
            case isSiteAdmin = "site_administrator"
            case hasPassedBackgroundCheck = "passed_background_check"
            case status = "status"
        }
    }

    public typealias Relationships = Empty

    public typealias Links = Empty

    public typealias Meta = Empty
}

//
//  Person.swift
//  
//
//  Created by Joseph Van Boxtel on 6/18/19.
//

import Foundation
import GenericJSON

public struct Person: ResourceProtocol {
    public struct Attributes: Codable {
        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case lastName = "last_name"
            case namePrefix = "name_prefix"
            case nameSuffix = "name_suffix"
            case givenName = "given_name"
            case middleName = "middle_name"
            case fullName = "full_name"
            case nickname
            
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case anniversary
            case birthdate
            case loggedInAt = "logged_in_at"
            
            case photo = "photo_url"
            case thumnailPhoto = "photo_thumnail_url"
            case permissions
            case maxPermissions = "max_permissions"
            case isSiteAdmin = "site_administrator"
            case notes
            case hasPassedBackgroundCheck = "passed_background_check"
            case status = "status"
        }
        
        // MARK: Name Fields
        public var firstName: String?
        public var lastName: String?
        public var namePrefix: String?
        public var nameSuffix: String?
        public var givenName: String?
        public var middleName: String?
        public var fullName: String?
        public var nickname: String?
        
        // MARK: Date Fields
        public var createdAt: Date?
        public var updatedAt: Date?
        public var anniversary: Date?
        public var birthdate: Date?
        public var loggedInAt: Date?
        
        // MARK: Other Fields
        public var photo: URL?
        public var thumnailPhoto: URL?
        public var permissions: String? // Model this?
        public var maxPermissions: String? // TODO: Use an enum
        public var isSiteAdmin: Bool?
        public var notes: String
        public var hasPassedBackgroundCheck: Bool?
        public var status: String // TODO: Use an enum?
    }
    
    public struct Relationships: Codable {
        enum CodingKeys: String, CodingKey {
            case parent = "parent_id"
        }
        public var createdBy: ResourceIdentifier<Person>?
        public var updatedBy: ResourceIdentifier<Person>?
    }
    
    public typealias Links = Empty
    public typealias Meta = Empty
}

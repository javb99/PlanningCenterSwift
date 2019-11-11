//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 11/10/19.
//

import Foundation
import JSONAPISpec

extension Models {
    public struct Organization {}
}

extension Models.Organization: ResourceProtocol {
    
    public struct Attributes: Codable {
        
        enum CodingKeys: String, CodingKey {
            case countryCode = "country_code"
            case dateFormat = "date_format"
            case name
            case timeZone = "time_zone"
        }
        
        public var countryCode: String
        
        public var dateFormat: String
        
        public var name: String
        
        public var timeZone: String
    }
    
    public typealias Relationships = Empty
    
    public typealias Links = Empty
    
    public typealias Meta = Empty
}

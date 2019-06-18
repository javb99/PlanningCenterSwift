//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/16/19.
//

import Foundation
import GenericJSON

/// The structure of responses and requests according the JSON:API.
/// Must contain at least one of `data`, `errors`, or `meta`, but `errors` and `data` must not both be present.
public struct Document: JSONDecodable {
    
    public var data: TopLevelData?
    public var errors: [APIError]?
    public var meta: Meta?
    
    
    public var jsonapi: JSON?
    
    /// `Link` objects that are related to the data such as `self` and pagination links.
    public var links: Links?
    
    /// Additional resources that are related to the data for this document.
    /// Must be `nil` if `data` is `nil`.
    public var included: [Resource]?
    
    public init(json: JSON) throws {
        if let dataJSON: JSON = json["data"] {
            data = try TopLevelData(json: dataJSON)
        } else { data = nil }
        
        errors = try json["errors"]?.asArray()
        
        if let metaJSON: JSON = json["meta"] {
            meta = try Meta(json: metaJSON)
        } else { meta = nil }
        
        jsonapi = json["jsonapi"]
        
        links = try json["links"]?.asDictionary()
        
        included = try json["included"]?.asArray()
    }
}

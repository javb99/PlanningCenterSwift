//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/16/19.
//

import Foundation
import GenericJSON

public typealias ResourceLinkage = DataWrapper<AnyResourceIdentifier>

public struct Relationship: JSONDecodable {
    // Must contain at least one.
    public var resourceLinkage: ResourceLinkage?
    public var links: Links?  //self, related, pagination
    public var meta: JSON?
    
    public init(json: JSON) throws {
        if let dataJSON: JSON = json["data"] {
            resourceLinkage = try ResourceLinkage(json: dataJSON)
        } else { resourceLinkage = nil }
        
        meta = json["meta"]
        
        links = try json["links"]?.asCompactDictionary()
        
        guard resourceLinkage != nil || meta != nil || links != nil else {
            throw ResourceDecodeError.incorrectStructure(reason: "Must have at least one of data, meta, or links")
        }
    }
}

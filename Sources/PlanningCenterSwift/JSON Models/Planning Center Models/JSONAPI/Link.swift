//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/16/19.
//

import Foundation
import GenericJSON

public typealias Links = [String: Link]

public struct Link: JSONDecodable {
    public var href: URL
    
    //public let meta: JSON?  I don't think PC uses the meta
    
    public init(json: JSON) throws {
        if let string = json.stringValue, let url = URL(string: string) {
            href = url
        } else {
            throw ResourceDecodeError.failedToParseAttribute("links")
        }
        
        //meta = json["meta"]
    }
}

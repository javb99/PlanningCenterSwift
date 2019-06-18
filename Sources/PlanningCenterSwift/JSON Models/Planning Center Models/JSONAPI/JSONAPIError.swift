//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/16/19.
//

import Foundation
import GenericJSON

/// An error returned as the json response from the server.
public struct APIError: JSONDecodable {
    /// A unique identifier for this particular occurrence of the problem.
    var id: String?
    
    /// a links object containing the following members: about
    var links: Links?
    
    /// the HTTP status code applicable to this problem, expressed as a string value.
    //var httpStatus: HTTPStatus?
    
    /// an application-specific error code, expressed as a string value.
    //var apiCode: PCErrorCode?
    
    /// a short, human-readable summary of the problem that SHOULD NOT change from occurrence to occurrence of the problem, except for purposes of localization.
    var title: String?
    
    /// a human-readable explanation specific to this occurrence of the problem. Like title, this field’s value can be localized.
    var detail: String?
    
    // var source: ???
    
    /// a meta object containing non-standard meta-information about the error.
    var meta: JSON?
    
    public init(json: JSON) throws {
        id = json["id"]
        links = try json["links"]?.asDictionary()
        title = json["title"]
        detail = json["detail"]
        meta = json["meta"]
    }
}

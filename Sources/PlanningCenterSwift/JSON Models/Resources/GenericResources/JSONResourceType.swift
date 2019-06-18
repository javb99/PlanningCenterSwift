//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/17/19.
//

import Foundation
import GenericJSON

/// A `JSONResourceType` knows how to go from JSON to a model object.
/// It is derived from `ResourceType` and implements its `makeModel(:Data)`
/// requirement by parsing the data into a `JSON` object and calling `makeModel(:JSON)`.
public protocol JSONResourceType: ResourceType {
    func makeModel(_ json: JSON) throws -> Model
}

extension JSONResourceType {
    /// Parsing from `Data` can happen automatically using `makeModel(:JSON)`.
    public func makeModel(_ data: Data) throws -> Model {
        let json = try JSONDecoder().decode(JSON.self, from: data)
        return try makeModel(json)
    }
}

extension JSONResourceType where Model: JSONDecodable {
    /// Parsing from `JSON` can happen automatically if `Model` implements `JSONDecodable`
    public func makeModel(_ json: JSON) throws -> Model {
        return try Self.Model(json: json)
    }
}

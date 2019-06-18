//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/16/19.
//

import Foundation
import GenericJSON

public struct Resource: JSONDecodable {
    
    public var identifer: AnyResourceIdentifier
    
    public var links: Links?
    private var relationships: [String: Relationship]?
    private var attributes: JSON?//Attributes?  // No links or relationships allowed
    public var meta: JSON?
    
    public var isOnlyIdentifier: Bool {
        return links == nil && relationships == nil && attributes == nil
    }
    
    public init(json: JSON) throws {
        
        identifer = try AnyResourceIdentifier(json: json)
        
        attributes = json["attributes"]
        
        relationships = try json["relationships"]?.asDictionary()
        
        links = try json["links"]?.asDictionary()
        
        meta = json["meta"]
    }
    
    /// Return the field specified by `key` throwing an error if it fails.
    /// - Throws: JSONDecodeError if the relationships are not present or do not match the expected single data value.
    func attribute(for key: String) throws -> JSON {
        guard let attributes = attributes else {
            throw ResourceDecodeError.incorrectStructure(reason: "Accessing attributes when it doesn't exist.")
        }
        guard let value: JSON = attributes[key], !value.isNull else {
            throw ResourceDecodeError.failedToParseAttribute(identifer.type+"."+key)
        }
        return value
    }
    
    /// Return the to-one relationship specified by `key` throwing an error if it fails.
    /// - Throws: JSONDecodeError if the relationships are not present or do not match the expected single data value.
    func toOneRelationship<T>(for key: String) throws -> ResourceIdentifier<T> {
        guard let relationships = relationships else {
            throw ResourceDecodeError.incorrectStructure(reason: "Accessing relationships when it doesn't exist.")
        }
        guard let relation = relationships[key]?.resourceLinkage?.asSingle else {
            throw ResourceDecodeError.failedToParseRelationship(identifer.type+"."+key)
        }
        return try relation.specialize()
    }
    
    /// Return the to-many relationship specified by `key` throwing an error if it fails.
    /// - Throws: JSONDecodeError if the relationships are not present or do not match the expected multiple data value.
    func toManyRelationship<T>(for key: String) throws -> [ResourceIdentifier<T>] {
        guard let relationships = relationships else {
            throw ResourceDecodeError.incorrectStructure(reason: "Accessing relationships when it doesn't exist.")
        }
        guard let relations = relationships[key]?.resourceLinkage?.asMultiple else {
            throw ResourceDecodeError.failedToParseRelationship(identifer.type+"."+key)
        }
        return relations.compactMap { relation in
            return try? relation.specialize()
        }
    }
    
    /// Return the field specified by `key` if it is present and not null otherwise nil.
    func attributeIfPresent(for key: String) -> JSON? {
        guard let value: JSON = attributes?[key], !value.isNull else {
            return nil
        }
        return value
    }
    
    /// Return the to-one relationship specified by `key` if it is present otherwise nil.
    func toOneRelationshipIfPresent<T>(for key: String) -> ResourceIdentifier<T>? {
        return try? toOneRelationship(for: key)
    }
    
    /// Return the to-many relationship specified by `key` if it is present otherwise nil.
    func toManyRelationshipIfPresent<T>(for key: String) -> [ResourceIdentifier<T>]? {
        return try? toManyRelationship(for: key)
    }
}

extension AnyResourceIdentifier: JSONDecodable {
    
    public init(json: JSON) throws {
        if let value = json["type"]?.stringValue {
            type = value
        } else {
            throw ResourceDecodeError.failedToParseAttribute("type")
        }
        
        if let value = json["id"]?.stringValue {
            id = value
        } else {
            throw ResourceDecodeError.failedToParseAttribute("id")
        }
        meta = nil
    }
}

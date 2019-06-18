//
//  PCResourceDecodable.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 4/8/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

/// Declares the ability to initialize from a JSON API Resource.
public protocol ResourceDecodable: Hashable {
    
    var id: ResourceIdentifier<Self> { get set }
    
    /// The type of JSON:API object.
    static var resourceType: String { get }
    
    init(resource: Resource) throws
}

extension ResourceDecodable {
    public static var resourceType: String {
        return "\(type(of: self))"
    }
}

extension ResourceDecodable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Resources are equal if they have the same id.
public func ==<T: ResourceDecodable>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}

extension APIResourceType where Model: ResourceDecodable {

    /// Create a single of PCResourceDecodable objects from a JSON API document.
    public func makeModel(_ document: Document) throws -> Model {
        guard let resource = document.data?.asSingle else {
            throw ResourceDecodeError.incorrectStructure(reason: "The Document's primary data field is missing or not a single object as expected.")
        }
        return try Model(resource: resource)
    }
}

public protocol SequenceInitializable: Sequence {
    init<S: Sequence>(_ sequence: S) where S.Element == Element
}
extension Array: SequenceInitializable {}

extension APIResourceType where Model: Collection & SequenceInitializable, Model.Element: ResourceDecodable {
    /// Create an array of PCResourceDecodable objects from a JSON API document.
    public func makeModel(_ document: Document) throws -> Model {
        guard let resources = document.data?.asMultiple else {
            throw ResourceDecodeError.incorrectStructure(reason: "The Document's primary data field is missing or not an array object as expected.")
        }
        return try Model.init(resources.compactMap(Model.Element.init(resource:)))
    }
}

extension Array where Element: ResourceDecodable {
    /// Transform an array of JSON API resources into an array of PCResourceDecodable objects.
    /// This isn't used as a default. This is to make unique requests easier to write.
    public init(resources: [Resource]) throws {
        try self.init(resources.compactMap {
            return try Element.init(resource: $0)
        })
    }
}

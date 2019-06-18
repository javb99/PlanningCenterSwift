//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/17/19.
//

import Foundation
import GenericJSON

public protocol ResourceIdentifierType: Hashable {
    var type: String { get }
    var id: String { get }
    var meta: JSON? { get }
}

extension ResourceIdentifierType {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(self.type)
    }
    
    /// Resources are equal if they have the same id and the same resource type.
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type
    }
}

/// Resources are equal if they have the same id and the same resource type.
public func ==<A: ResourceIdentifierType, B: ResourceIdentifierType>(lhs: A, rhs: B) -> Bool {
    return lhs.id == rhs.id && lhs.type == rhs.type
}

public struct ResourceIdentifier<T: ResourceDecodable>: ResourceIdentifierType {
    
    public var type: String {
        return T.resourceType
    }
    
    public var id: String
    
    public var meta: JSON? = nil
    
    public func eraseToAny() -> AnyResourceIdentifier {
        return AnyResourceIdentifier(type: type, id: id, meta: meta)
    }
}

public struct AnyResourceIdentifier: ResourceIdentifierType {
    public var type: String
    public var id: String
    public var meta: JSON? = nil
    
    /// Effectively casts from an unknown resource identifier to a known type.
    /// Throws an error if the type doesn't match the resource type of the generic type.
    public func specialize<T>(to valueType: T.Type = T.self) throws -> ResourceIdentifier<T> {
        // This signature allows the call site to specify the generic
        // constraint if it is unclear or omit it if it can be easily inferred.
        
        guard self.type == valueType.resourceType else {
            throw ResourceDecodeError.wrongType(expected: valueType.resourceType)
        }
        return ResourceIdentifier<T>(id: id, meta: meta)
    }
}

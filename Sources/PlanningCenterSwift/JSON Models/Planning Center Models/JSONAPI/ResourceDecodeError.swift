//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/16/19.
//

import Foundation
import GenericJSON

public enum ResourceDecodeError: Error, LocalizedError {
    case incorrectStructure(reason: String)
    case wrongType(expected: String)
    case failedToParseAttribute(String)
    case failedToParseRelationship(String)
    case invalidCast(from: JSON, to: Any.Type)
    
    public var errorDescription: String {
        switch self {
        case let .incorrectStructure(reason: reason):
            return "Incorrect structure: " + reason
        case let .wrongType(expected: expectedType):
            return "Invalid type, expected: " + expectedType
        case let .failedToParseAttribute(field):
            return "Failed to parse attribute: " + field
        case let .failedToParseRelationship(relationship):
            return "Failed to parse relationship: " + relationship
        case let .invalidCast(from: realType, to: failedType):
            return "Failed to represent \(realType) as \(failedType)"
        }
    }
}

//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/16/19.
//

import Foundation
import GenericJSON

public typealias TopLevelData = DataWrapper<Resource>

public enum DataWrapper<T: JSONDecodable>: JSONDecodable {
    
    case null
    case single(T) // Could only be ID portion
    case multiple([T]) // Could only be ID portion
    
    public init(json: JSON) throws {
        if json.isNull {
            self = .null
        } else if let array: [T] = try? json.asArray() {
            self = .multiple(array)
        } else {
            self = try .single(T(json: json))
        }
    }
    
    var asMultiple: [T]? {
        switch self {
        case let .multiple(array):
            return array
        default:
            return nil
        }
    }
    
    var asSingle: T? {
        switch self {
        case let .single(json):
            return json
        default:
            return nil
        }
    }
}

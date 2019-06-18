//
//  JSON+OtherTypes.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 4/9/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import GenericJSON

/// Return Type inferred subscript accessors.
extension JSON {
    
    /// Just pass the key to the underlying json.
    subscript(key: String) -> Int? {
        get {
            return self[key]?.intValue
        }
    }
    
    /// Just pass the key to the underlying json.
    subscript(key: String) -> String? {
        get {
            return self[key]?.stringValue
        }
    }
    
    /// Just pass the key to the underlying json.
    subscript(key: String) -> Bool? {
        get {
            return self[key]?.boolValue
        }
    }
    
    /// Just pass the key to the underlying json.
    subscript(key: String) -> Date? {
        get {
            return self[key]?.dateValue
        }
    }
    
    /// Just pass the key to the underlying json.
    subscript(key: String) -> URL? {
        get {
            return self[key]?.urlValue
        }
    }
    
    /// Just pass the key to the underlying json.
    subscript(key: String) -> Float? {
        get {
            return self[key]?.floatValue
        }
    }
    
    /// Just pass the key to the underlying json.
    subscript(key: String) -> [String]? {
        get {
            return self[key]?.arrayValue?.compactMap { singleJsonField in
                return singleJsonField.stringValue
            }
        }
    }
}

extension JSON {
    
    /// Parse the floatValue and create an `Int` from it.
    var intValue: Int? {
        return floatValue.map(Int.init(_:))
    }
    
    /// Parse the stringValue using `pcjsonDateAndTimeFormatter`.
    var dateValue: Date? {
        return stringValue.flatMap { pcjsonDateAndTimeFormatter.date(from: $0) }
    }
    
    /// Interpret as a url string.
    var urlValue: URL? {
        return stringValue.flatMap { URL(string: $0) }
    }
    
    /// Treat as a `String`. Throws a `JSONDecodeError` if this is not representing a `String`.
    func asString() throws -> String {
        guard let string = self.stringValue else {
            throw ResourceDecodeError.invalidCast(from: self, to: String.self)
        }
        return string
    }
    
    /// Treat as an `Int`. Throws a `JSONDecodeError` if this is not representing an `Int`.
    func asInt() throws -> Int {
        guard let int = self.intValue else {
            throw ResourceDecodeError.invalidCast(from: self, to: Int.self)
        }
        return int
    }
    
    /// Treat as a `Bool`. Throws a `JSONDecodeError` if this is not representing a `Bool`.
    func asBool() throws -> Bool {
        guard let bool = self.boolValue else {
            throw ResourceDecodeError.invalidCast(from: self, to: Bool.self)
        }
        return bool
    }
    
    /// Treat as a `Date` in ISO8601 format. Throws a `JSONDecodeError` if this is not representing a `Date`.
    func asDate() throws -> Date {
        guard let date = dateValue else {
            throw ResourceDecodeError.invalidCast(from: self, to: Date.self)
        }
        return date
    }
    
    /// Treat as a `URL`. Throws a `JSONDecodeError` if this is not representing a `URL` as a string.
    func asURL() throws -> URL {
        guard let url = try URL(string: asString()) else {
            throw ResourceDecodeError.invalidCast(from: self, to: URL.self)
        }
        return url
    }
    
    /// Decode using `init(json:)` of the inferred return type. Rethrows any error from the initializer.
    func decode<T: JSONDecodable>() throws -> T {
        return try T.init(json: self)
    }
    
    /// Treat as an `Array`. Throws a `JSONDecodeError` if this is not representing an `Array`.
    func asArray() throws -> [JSON] {
        guard let array = self.arrayValue else {
            throw ResourceDecodeError.invalidCast(from: self, to: Array<JSON>.self)
        }
        return array
    }
    
    /// Treat as an `Array` of any `JSONDecodable` type specified by type inference. Throws a `JSONDecodeError` if this is not representing an `Array` of `JSONDecodable` elements.
    func asArray<T: JSONDecodable>() throws -> [T] {
        return try asArray().map(T.init(json:))
    }
    
    /// Treat as a `Dictionary`. Throws a `JSONDecodeError` if this is not representing a `Dictionary`.
    func asDictionary() throws -> [String: JSON] {
        guard let dictionary = self.objectValue else {
            throw ResourceDecodeError.invalidCast(from: self, to: Dictionary<String, JSON>.self)
        }
        return dictionary
    }
    
    /// Treat as a `Dictionary` with values that are any `JSONDecodable` type specified by type inference. Throws a `JSONDecodeError` if this is not representing a `Dictionary` of `JSONDecodable` values.
    func asDictionary<T: JSONDecodable>() throws -> [String: T] {
        return try asDictionary().mapValues(T.init(json:))
    }
}

public let pcjsonDateAndTimeFormatter = DateFormatter.iso8601

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

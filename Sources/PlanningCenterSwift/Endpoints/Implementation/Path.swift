//
//  Path.swift
//  
//
//  Created by Joseph Van Boxtel on 8/16/19.
//

import Foundation

public struct Path {
    public static var root: Path { return Path(components: []) }
    
    private(set) var components: [String]
    
    public mutating func append(_ component: String) {
        components.append(component)
    }
    
    public func appending(_ component: String) -> Path {
        var new = self
        new.append(component)
        return new
    }
    
    public mutating func append(_ path: Path) {
        components.append(contentsOf: path.components)
    }
    
    public func appending(_ path: Path) -> Path {
        var new = self
        new.append(path)
        return new
    }
    
    public func buildString() -> String {
        "/" + components.joined(separator: "/")
    }
    
    public static func +(_ lhs: Path, _ rhs: Path) -> Path {
        return lhs.appending(rhs)
    }
    
    public static func += (_ lhs: inout Path, rhs: Path) {
        lhs.append(rhs)
    }
}

extension Path: ExpressibleByArrayLiteral {
    
    public typealias ArrayLiteralElement = String
    
    public init(arrayLiteral elements: Self.ArrayLiteralElement...) {
        self.init(components: elements)
    }
}

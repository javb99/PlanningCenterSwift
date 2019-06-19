//
//  FetchableByIdentifier.swift
//  
//
//  Created by Joseph Van Boxtel on 6/19/19.
//

import Foundation

/// A model object that has a url that fits the form, `host/a/path/to/a/collection/{id}`
public protocol FetchableByIdentifier {
    /// The path to the collection of a model. `/IDENTIFIER` will be appended to create the full path.
    static var collectionPath: String { get }
}

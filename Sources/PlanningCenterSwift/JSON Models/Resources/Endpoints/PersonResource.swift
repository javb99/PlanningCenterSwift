//
//  PersonResource.swift
//  
//
//  Created by Joseph Van Boxtel on 6/19/19.
//

import Foundation

public typealias PersonResource = SingleResource<Person>

extension Person: FetchableByIdentifier {
    public static var collectionPath: String {
        return "people"
    }
}

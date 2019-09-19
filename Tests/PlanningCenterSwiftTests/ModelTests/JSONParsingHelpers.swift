//
//  JSONParsingHelpers.swift
//  
//
//  Created by Joseph Van Boxtel on 9/18/19.
//

import Foundation
import PlanningCenterSwift

func decode<T: Decodable>(_ jsonString: String, using decoder: JSONDecoder = .pco) throws -> T {
    let data = jsonString.data(using: .utf8)!
    return try decoder.decode(T.self, from: data)
}

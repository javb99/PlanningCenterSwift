//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/17/19.
//

import Foundation

public protocol AuthenticationProvider {
    /// Added to the HTTP headers by the `ResourceService`.
    var authenticationHeader: (key: String, value: String)? { get }
}

//
//  BasicAuthenticationProvider.swift
//  
//
//  Created by Joseph Van Boxtel on 10/11/19.
//

import Foundation

public struct BasicAuthenticationProvider: AuthenticationProvider {
    public var authenticationHeader: (key: String, value: String)?
    
    /// Creates an object that can be used to authenticate requests
    /// - Parameter id: The user id, must not include the colon ':'
    /// - Parameter password: The password
    public init?(id: String, password: String) {
        guard !id.contains(":") else { return nil }
        
        let value = id + ":" + password
        guard let utf8Value = value.data(using: .utf8) else { return nil }
        let encodedValue = utf8Value.base64EncodedString()
        authenticationHeader = (key: "Authorization", value: "Basic " + encodedValue)
    }
}

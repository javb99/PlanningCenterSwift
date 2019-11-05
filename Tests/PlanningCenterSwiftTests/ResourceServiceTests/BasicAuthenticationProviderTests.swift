//
//  BasicAuthenticationProviderTests.swift
//  ServicesSchedulerTests
//
//  Created by Joseph Van Boxtel on 9/21/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import XCTest
import PlanningCenterSwift

class BasicAuthenticationProviderTests: XCTestCase {

    func test_providedAuthentication_isNotNil() {
        let sut = BasicAuthenticationProvider(id: "AnID", password: "APassword")
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut!.authenticationHeader)
    }
    
    func test_usernameIncludingColon_returnsNilProvider() {
        let sut = BasicAuthenticationProvider(id: "AnID:", password: "APassword")
        XCTAssertNil(sut)
    }
    
    func test_providedAuthentication_isBase64() {
        let sut = BasicAuthenticationProvider(id: "AnID//asdf", password: "APassword")
        let headerValue = sut!.authenticationHeader?.value.dropFirst("Basic ".count)
        
        let unfilteredLength = headerValue!.count
        let filteredLength = headerValue!.unicodeScalars.filter(CharacterSet.base64Allowed.contains).count
        
        XCTAssertEqual(filteredLength, unfilteredLength)
    }
}

// MARK: Helpers

extension CharacterSet {
    static var base64Allowed: CharacterSet {
        var set = CharacterSet.alphanumerics
        let letters = "abcdefghijklmopqrstuvwxyz"
        let numbers = "0123456789"
        let symbols = "+/="
        set.insert(charactersIn: letters+letters.uppercased()+numbers+symbols)
        return set
    }
}

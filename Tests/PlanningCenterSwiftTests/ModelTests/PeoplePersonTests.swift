//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 11/11/19.
//

import XCTest
import JSONAPISpec
import PlanningCenterSwift

final class PeoplePersonTests: XCTestCase {
    
    func test_decode_success() {
        let person: ResourceDocument<Models.PeoplePerson> = try! decode(PeoplePersonJSON.sample)
        
        XCTAssertEqual(person.data?.identifer.id, "25452054")
    }
    func test_withAnniversary_decode_success() {
        let person: ResourceDocument<Models.PeoplePerson> = try! decode(PeoplePersonJSON.withAniversary)
        
        XCTAssertNotNil(person.data?.anniversary)
    }
}

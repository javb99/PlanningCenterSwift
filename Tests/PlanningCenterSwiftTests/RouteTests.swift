//
//  RouteTests.swift
//  
//
//  Created by Joseph Van Boxtel on 8/7/19.
//

import XCTest
import JSONAPISpec
@testable import PlanningCenterSwift

final class RouteTests: XCTestCase {

    func testCollectionEndpoints() {
        XCTAssertEqual(Endpoints.services.folders.path.buildString(), "/services/v2/folders")
        XCTAssertEqual(Endpoints.services.folders[id: "10"].subfolders.path.buildString(), "/services/v2/folders/10/folders")
        XCTAssertEqual(Endpoints.services.folders.create.path.buildString(), "/services/v2/folders")
    }
    
    func testIndividualEndpoints() {
        XCTAssertEqual(Endpoints.services.folders[id: "10"].path.buildString(), "/services/v2/folders/10")
        XCTAssertEqual(Endpoints.services.folders[id: "10"].subfolders.path.buildString(), "/services/v2/folders/10/folders")
        XCTAssertEqual(Endpoints.services.folders[id: "10"].subfolders[id: "20"].path.buildString(), "/services/v2/folders/10/folders/20")
        XCTAssertEqual(Endpoints.services.folders[id: "10"].subfolders[id: "20"].serviceTypes[id: "12"].path.buildString(), "/services/v2/folders/10/folders/20/service_types/12")
    }
    
    func testUpdatableEndpoints() {
        let endpoint = Endpoints.services.folders[id: "10"].update
        XCTAssertEqual(endpoint.path.buildString(), "/services/v2/folders/10")
        XCTAssertEqual(endpoint.method, HTTPMethod.patch)
    }
    
    func testDeletableEndpoints() {
        let endpoint = Endpoints.services.folders[id: "10"].delete
        XCTAssertEqual(endpoint.path.buildString(), "/services/v2/folders/10")
        XCTAssertEqual(endpoint.method, HTTPMethod.delete)
    }
}

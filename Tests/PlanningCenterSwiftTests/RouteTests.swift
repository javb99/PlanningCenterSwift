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
        XCTAssertEqual(Endpoints.folders.path.buildString(), "/folders")
        XCTAssertEqual(Endpoints.folders[id: "10"].subfolders.path.buildString(), "/folders/10/folders")
        XCTAssertEqual(Endpoints.folders.create.path.buildString(), "/folders")
    }
    
    func testIndividualEndpoints() {
        XCTAssertEqual(Endpoints.folders[id: "10"].path.buildString(), "/folders/10")
        XCTAssertEqual(Endpoints.folders[id: "10"].subfolders.path.buildString(), "/folders/10/folders")
        XCTAssertEqual(Endpoints.folders[id: "10"].subfolders[id: "20"].path.buildString(), "/folders/10/folders/20")
        XCTAssertEqual(Endpoints.folders[id: "10"].subfolders[id: "20"].serviceTypes[id: "12"].path.buildString(), "/folders/10/folders/20/service_types/12")
        Endpoints.folders[id: "10"].delete
    }
    
    func testUpdatableEndpoints() {
        let endpoint = Endpoints.folders[id: "10"].update
        XCTAssertEqual(endpoint.path.buildString(), "/folders/10")
        XCTAssertEqual(endpoint.method, HTTPMethod.patch)
    }
    
    func testDeletableEndpoints() {
        let endpoint = Endpoints.folders[id: "10"].delete
        XCTAssertEqual(endpoint.path.buildString(), "/folders/10")
        XCTAssertEqual(endpoint.method, HTTPMethod.delete)
    }
}

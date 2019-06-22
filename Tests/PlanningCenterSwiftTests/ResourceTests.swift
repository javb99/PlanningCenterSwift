//
//  JsonSample.swift
//  
//
//  Created by Joseph Van Boxtel on 6/22/19.
//

import XCTest
@testable import PlanningCenterSwift

struct JsonSample<R: ResourceDecodable> {
    //var modelType: ResourceDecodable.Type
    var live: String
    var spec: String
    
    var liveData: Data {
        return live.data(using: .utf8)!
    }
    var specData: Data {
        return spec.data(using: .utf8)!
    }
    
    var modelTypeName: String {
        return String(describing: R.self)
    }
}

//final class ResourceTests: XCTestCase {
//
//    func testParseTypesFromResource() {
//        let samples = [planJsonSample]
//        for sample in samples {
//            do {
//                try parseResource(sample.modelType, from: sample.liveData)
//            } catch {
//                XCTAssertTrue(false, "Parse \(sample.modelTypeName) sample failed: \(error)")
//            }
//            do {
//                try parseResource(sample.modelType, from: sample.specData)
//            } catch {
//                XCTAssertTrue(false, "Parse \(sample.modelTypeName) spec failed: \(error)")
//            }
//        }
//    }
//
//    static var allTests = [
//        ("testParseTypesFromResource", testParseTypesFromResource),
//    ]
//}

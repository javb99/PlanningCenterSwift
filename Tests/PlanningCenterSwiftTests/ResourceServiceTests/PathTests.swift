//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 9/18/19.
//

import XCTest
import PlanningCenterSwift

class PathTests: XCTestCase {
    
    func test_init_empty_isSingleSlash() {
        let sut: Path = []
        XCTAssertEqual(sut.buildString(), "/")
    }
    
    func test_init_root_isSingleSlash() {
        let sut: Path = .root
        XCTAssertEqual(sut.buildString(), "/")
    }
    
    func test_init_severalComponents_separatedBySlash() {
        let sut: Path = ["a", "b", "c"]
        XCTAssertEqual(sut.buildString(), "/a/b/c")
    }
    
    func test_append_severalComponents_separatedBySlash() {
        let sutA: Path = ["a", "b", "c"]
        let sutB: Path = ["d", "e", "f"]
        let sut = sutA + sutB
        XCTAssertEqual(sut.buildString(), "/a/b/c/d/e/f")
    }
    
    func test_appending_severalComponents_separatedBySlash() {
        var sut: Path = ["a", "b", "c"]
        let sutB: Path = ["d", "e", "f"]
        sut += sutB
        XCTAssertEqual(sut.buildString(), "/a/b/c/d/e/f")
    }
}

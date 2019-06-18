import XCTest
@testable import PlanningCenterSwift

final class PlanningCenterSwiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PlanningCenterSwift().text, "Hello, World!")
        XCTAssertEqual(Plan.resourceType, "Plan")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

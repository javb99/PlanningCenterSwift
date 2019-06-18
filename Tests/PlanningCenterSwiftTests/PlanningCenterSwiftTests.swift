import XCTest
@testable import PlanningCenterSwift

final class PlanningCenterSwiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PlanningCenterSwift().text, "Hello, World!")
        XCTAssertEqual(Plan.resourceType, "Plan")
        guard let date = pcjsonDateAndTimeFormatter.date(from: "2019-06-12T19:00:00Z") else {
            XCTAssertFalse(true)
            return
        }
        XCTAssertEqual(pcjsonDateAndTimeFormatter.string(from: date), "2019-06-12T19:00:00Z")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

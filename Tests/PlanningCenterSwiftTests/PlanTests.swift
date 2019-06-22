import XCTest
@testable import PlanningCenterSwift

final class PlanTests: XCTestCase {
    
    //let bundle = Bundle.init(for: Self.self)
    
    func testParseSpec() {
        parse(planJsonSample.specData)
    }
    
    func testParseSample() {
        parse(planJsonSample.liveData)
    }
    
    func parse(_ data: Data) {
        do {
            let _ = try parseResource(Plan.self, from: data)
        } catch {
            XCTAssertTrue(false, "Failed to parse: \(error)")
        }
    }
    
    static var allTests = [
        ("testParseSpec", testParseSpec),
        ("testParseSample", testParseSample),
    ]
}

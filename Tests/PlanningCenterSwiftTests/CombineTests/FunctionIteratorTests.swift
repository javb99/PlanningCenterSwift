//
//  Created by Joseph Van Boxtel on 11/25/19.
//

import Foundation
import XCTest
@testable import PlanningCenterSwift

class FunctionIteratorTests: XCTestCase {
    
    func test_iterator() {
        let seq = FunctionSequence<Int>.positiveAscending
        let firstThree = Array(seq.prefix(3))
        XCTAssertEqual(firstThree, [0, 1, 2])
    }
}

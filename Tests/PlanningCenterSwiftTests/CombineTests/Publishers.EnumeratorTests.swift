//
//  Created by Joseph Van Boxtel on 11/25/19.
//

import Foundation
import Combine
import XCTest
@testable import PlanningCenterSwift

class EnumeratorPublisherTests: XCTestCase {
    
    func test_multipleElements_haveCorrectIndexes() {
        let source = SequencePublisher(sequence: ["a", "b", "c", "d"])
        let spy = SubscriberSpy<(Int, String), Never>()
        let sut = source.enumerated()
        sut.receive(subscriber: spy)
        
        spy.request(.max(3))
        
        XCTAssertEqual(spy.received.count, 3)
        assertEqual(spy.received[0], (0, "a"))
        assertEqual(spy.received[1], (1, "b"))
        assertEqual(spy.received[2], (2, "c"))
    }
}

// MARK: Helpers

typealias SequencePublisher<C: Sequence> = Publishers.Sequence<C, Never>

func assertEqual<U, V>(_ real: (U, V), _ expected: (U, V), file: StaticString = #file, line: UInt = #line) where U: Equatable, V: Equatable {
    XCTAssertEqual(real.0, expected.0, file: file, line: line)
    XCTAssertEqual(real.1, expected.1, file: file, line: line)
}

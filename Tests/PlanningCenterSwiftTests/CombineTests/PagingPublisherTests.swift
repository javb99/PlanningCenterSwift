//
//  Created by Joseph Van Boxtel on 11/18/19.
//

import Foundation
import XCTest
import Combine
@testable import PlanningCenterSwift

class PagingPublisherTests: XCTestCase {
    
    func test_receivesNoRequest_requestsNoPages() {
        let spy = SubscriberSpy<Int, Never>()
        let sut = PagingPublisher(pageSize: 10, upstream: Just([1, 2, 3]))
        sut.receive(subscriber: spy)
        
        
        XCTAssertEqual(spy.received.count, 0)
    }
    
    func test_receivesRequestOne_getsOne() {
        let spy = SubscriberSpy<Int, Never>()
        let sut = PagingPublisher(pageSize: 10, upstream: Just([1, 2, 3]))
        sut.receive(subscriber: spy)

        spy.request(.max(1))

        XCTAssertEqual(spy.received.count, 1)
    }
    
    func test_receivesRequestTwoPages_getsBoth() {
        let spy = SubscriberSpy<Int, Never>()
        let upstream = Publishers.Sequence(sequence: Array(repeating: 0, count: 1000)).flatMap{ _ in
            return Just([1, 2, 3])
        }.print("toSUT")
        let sut = PagingPublisher(pageSize: 10, upstream: upstream)
        sut.print("toSpy").receive(subscriber: spy)

        spy.request(.max(4))

        XCTAssertNil(spy.completion)
        XCTAssertEqual(spy.received.count, 4)
    }
    
    func test_receivesRequestTwoPagesSeparately_getsBoth() {
        let spy = SubscriberSpy<Int, Never>()
        let upstream = Publishers.Sequence(sequence: Array(repeating: 0, count: 1000)).flatMap{ _ in
            return Just([1, 2, 3])
        }.print("toSUT")
        let sut = PagingPublisher(pageSize: 10, upstream: upstream)
        sut.print("toSpy").receive(subscriber: spy)

        spy.request(.max(2))
        
        spy.request(.max(2))

        XCTAssertNil(spy.completion)
        XCTAssertEqual(spy.received.count, 4)
    }
    
    func test_upstreamCompletes_completes() {
        let spy = SubscriberSpy<Int, Never>()
        let upstream = Just([1, 2, 3])
        let sut = PagingPublisher(pageSize: 10, upstream: upstream)
        sut.receive(subscriber: spy)

        spy.request(.max(4))

        XCTAssertNotNil(spy.completion)
        XCTAssertEqual(spy.received.count, 3)
    }
    
    func test_upstreamCompletesWithExtraInBuffer_doesNotComplete() {
        let spy = SubscriberSpy<Int, Never>()
        let upstream = Just([1, 2, 3])
        let sut = PagingPublisher(pageSize: 10, upstream: upstream)
        sut.receive(subscriber: spy)

        spy.request(.max(2))

        XCTAssertNil(spy.completion)
        XCTAssertEqual(spy.received.count, 2)
    }
    
    func test_upstreamCompletesWithExtraInBuffer_thenEmptiesBuffer_completes() {
        let spy = SubscriberSpy<Int, Never>()
        let upstream = Just([1, 2, 3])
        let sut = PagingPublisher(pageSize: 10, upstream: upstream)
        sut.receive(subscriber: spy)

        spy.request(.max(2))
        XCTAssertNil(spy.completion)
        spy.request(.max(2))
        XCTAssertNotNil(spy.completion)
        
        XCTAssertEqual(spy.received.count, 3)
    }
    
    func test_requestsMinimumFromUpstream() {
        var upstreamRequested = Subscribers.Demand.none
        let spy = SubscriberSpy<Int, Never>()
        let upstream = Publishers.Sequence(sequence: Array(repeating: 0, count: 1000)).flatMap{ _ in
            return Just([1, 2, 3])
        }.handleEvents(receiveRequest: { demand in
            upstreamRequested += demand
        })
        let sut = PagingPublisher(pageSize: 3, upstream: upstream)
        sut.receive(subscriber: spy)
        
        spy.request(.max(8))

        XCTAssertNil(spy.completion)
        XCTAssertEqual(spy.received, [1,2,3, 1,2,3, 1,2])
        XCTAssertEqual(upstreamRequested, .max(3))
    }
}

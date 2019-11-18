//
//  Created by Joseph Van Boxtel on 11/18/19.
//

import Foundation
import Combine
import XCTest
@testable import PlanningCenterSwift

class OrdererPublisherTests: XCTestCase {
    func test_() {
        let (_, spy) = makeSUT(upstream: [(0,"a")])
        
        spy.request(.max(1))
        
        XCTAssertEqual(spy.received, ["a"])
    }
    
    func test_inOrder_remainsInOrder() {
        let (_, spy) = makeSUT(upstream: [(0, "a"), (1, "b")])
        
        spy.request(.max(2))
        
        XCTAssertEqual(spy.received, ["a", "b"])
    }
    
    func test_notInOrderFirstNotInDemand_returnsInOrder() {
        let (_, spy) = makeSUT(upstream: [(2, "c"), (1, "b"), (0, "a")])
        
        spy.request(.max(2))
        
        XCTAssertEqual(spy.received, ["a", "b"])
    }
    
    func test_notInOrderFirstNotUpstream_returnsNone() {
        let (_, spy) = makeSUT(upstream: [(2, "c")])
        
        spy.request(.max(1))
        
        XCTAssertNil(spy.completion)
        XCTAssertEqual(spy.received, [])
    }
    
    func test_cancel_cancelsUpstream() {
        var didCancelUpstream = false
        let upstream = Publishers.Sequence<[(Int, String)], Never>(sequence:[(0, "a")])
            .handleEvents(receiveCancel: {didCancelUpstream = true})
        
        let sut = Publishers.Orderer(upstream: upstream)
        
        let spy = SubscriberSpy<String, Never>()
        sut.receive(subscriber: spy)
        
        spy.cancel()
        
        XCTAssertTrue(didCancelUpstream)
    }
    
    // MARK: Helpers
    
    func makeSUT<Element>(upstream upstreamData: [(Int,Element)]) -> (Publishers.Orderer<Element, Publishers.Sequence<[(Int, Element)], Never>>, SubscriberSpy<Element, Never>) {
        
        let spy = SubscriberSpy<Element, Never>()
        let upstream = Publishers.Sequence<[(Int, Element)], Never>(sequence:upstreamData)
        let sut = Publishers.Orderer(upstream: upstream)
        sut.receive(subscriber: spy)
        return (sut, spy)
    }
}

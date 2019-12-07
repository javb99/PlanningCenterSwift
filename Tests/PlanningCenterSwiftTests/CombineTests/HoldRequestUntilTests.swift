//
//  Created by Joseph Van Boxtel on 12/7/19.
//

import Foundation
import XCTest
import Combine
@testable import PlanningCenterSwift

class HoldRequestUntilTests: XCTestCase {
    
    func test_notUnlocked_doesNotRequest() {
        var didRequest = false
        let upstream = SequencePublisher(sequence: [1, 2, 3]).handleEvents(receiveRequest: {_ in didRequest = true})
        let unlock = PassthroughSubject<Void, Never>()
        let sut = upstream.holdRequests(untilOutputFrom: unlock)
        let spy = SubscriberSpy<Int, Never>()
        sut.receive(subscriber: spy)
        
        spy.request(.max(1))
        
        XCTAssertFalse(didRequest)
    }
    
    func test_unlocked_requests() {
        var didRequest = false
        let upstream = SequencePublisher(sequence: [1, 2, 3]).handleEvents(receiveRequest: {_ in didRequest = true})
        let unlock = PassthroughSubject<Void, Never>()
        let sut = upstream.holdRequests(untilOutputFrom: unlock)
        let spy = SubscriberSpy<Int, Never>()
        sut.receive(subscriber: spy)
        
        spy.request(.max(1))
        XCTAssertFalse(didRequest)
        unlock.send()
        XCTAssertTrue(didRequest)
    }
    
    func test_unlocked_requestsAndReceives() {
        var didRequest = false
        let upstream = SequencePublisher(sequence: [1, 2, 3]).handleEvents(receiveRequest: {_ in didRequest = true})
        let unlock = PassthroughSubject<Void, Never>()
        let sut = upstream.holdRequests(untilOutputFrom: unlock)
        let spy = SubscriberSpy<Int, Never>()
        sut.receive(subscriber: spy)
        
        spy.request(.max(1))
        XCTAssertFalse(didRequest)
        unlock.send()
        XCTAssertTrue(didRequest)
        XCTAssertEqual(spy.received, [1])
    }
    
    func test_unlockedBeforeRequest_requestsAndReceives() {
        var didRequest = false
        let upstream = SequencePublisher(sequence: [1, 2, 3]).handleEvents(receiveRequest: {_ in didRequest = true})
        let unlock = PassthroughSubject<Void, Never>()
        let sut = upstream.holdRequests(untilOutputFrom: unlock)
        let spy = SubscriberSpy<Int, Never>()
        sut.receive(subscriber: spy)
        
        unlock.send()
        spy.request(.max(1))
        XCTAssertTrue(didRequest)
        XCTAssertEqual(spy.received, [1])
    }
    
    func test_unlockedBeforeRequest_requestsMutliple_receivesMutliple() {
        var didRequest = false
        let upstream = SequencePublisher(sequence: [1, 2, 3]).handleEvents(receiveRequest: {_ in didRequest = true})
        let unlock = PassthroughSubject<Void, Never>()
        let sut = upstream.holdRequests(untilOutputFrom: unlock)
        let spy = SubscriberSpy<Int, Never>()
        sut.receive(subscriber: spy)
        
        unlock.send()
        spy.request(.max(3))
        XCTAssertTrue(didRequest)
        XCTAssertEqual(spy.received, [1, 2, 3])
    }
    
    func test_requestsAroundUnlock_receivesAll() {
        var didRequest = false
        let upstream = SequencePublisher(sequence: [1, 2, 3, 4, 5]).handleEvents(receiveRequest: {_ in didRequest = true})
        let unlock = PassthroughSubject<Void, Never>()
        let sut = upstream.holdRequests(untilOutputFrom: unlock)
        let spy = SubscriberSpy<Int, Never>()
        sut.receive(subscriber: spy)
        
        spy.request(.max(2))
        unlock.send()
        spy.request(.max(3))
        
        XCTAssertEqual(spy.received, [1, 2, 3, 4, 5])
    }
}

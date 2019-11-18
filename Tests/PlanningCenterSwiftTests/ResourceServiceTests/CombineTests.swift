//
//  Created by Joseph Van Boxtel on 11/12/19.
//

import Foundation

import Foundation
import XCTest
import JSONAPISpec
@testable import PlanningCenterSwift
import Combine

/// Operators the respect Demand d
/// d     .map()
/// n*d   .collect(n)
/// d     .append(Sequence)
/// d     .append(Publisher)
/// d     .scan()
/// d     .assertNoFailure()
/// d     .removeDuplicates()
/// d     .replaceError()
/// d     .replaceEmpty()
/// d     .filter()
/// k  *  .flatMap(maxPublishers: k, {})
/// 1     .dropFirst()
/// min(n,d) .dropFirst(n)
/// n  *  .prefix(k)
/// n     .prefix(while:)
/// n  *  .output(at: k)
/// n  *  .output(in: )
/// n     .drop(untilOutputFrom: Publisher) demands 1 from paramer pub
/// n     .prefix(untilOutputFrom: Publisher) demands 1 from paramer pub
/// n     .zip() both demand n
/// 1     .merge() both demand 1 at a time. result is interleaved
/// n     .combineLatest() both demand n
/// n     .catch({})
/// n     .print()
///
///
/// Operators that don't respect Demand
/// unlimited .first()
/// unlimited .first(where:{})
/// unlimited .last()
/// unlimited .last(where:{})
/// unlimited .collect() can logically only reply to a demand of 1
/// unlimited .reduce(:,:)
/// unlimited .ignoreOutput()
/// unlimited .flatMap({})
/// unlimited .count()  by definition
/// unlimited .allSatisfy()
/// unlimited .contains()
/// ....      .multicast()
/// unlimited .switchToLatests()
///

class ListEndpointPublisherTests: XCTestCase {

//    func test_() {
//        let sut = ListEndpointPublisher(endpoint: Endpoints.services.planPeople, network: MockNetwork())
//
////        let prefixed = sut.first()
////        var receivedCount = 0
////        let exp = expectation(description: "completes")
//
////        let sub = AnySubscriber<[Int], NetworkError>(receiveSubscription: { $0.request(.max(10)) }, receiveValue: { _ in return .max(1) }, receiveCompletion: {_ in })
//
//        let p = sut.map{_ in sut}.receive(subscriber: SubscriberSpy())
////        let s = prefixed.sink(receiveCompletion: {_ in
////            exp.fulfill()
////        }, receiveValue: { _ in receivedCount += 1 })
////        wait(for: [exp], timeout: 2)
////        XCTAssertEqual(receivedCount, 5)
//    }
    
    func test_receivesNoRequest_requestsNoPages() {
        let spy = SubscriberSpy<Int, Never>()
        let sut = PagingPublisher(upstream: Just([1, 2, 3]))
        sut.receive(subscriber: spy)
        
        
        XCTAssertEqual(spy.received.count, 0)
    }
    
    func test_receivesRequestForNone_requestsNoPages() {
        let spy = SubscriberSpy<Int, Never>()
        let sut = PagingPublisher(upstream: Just([1, 2, 3]))
        sut.receive(subscriber: spy)
        
        spy.request(.none)
        
        XCTAssertEqual(spy.received.count, 0)
    }
    
    func test_receivesRequestOne_getsOne() {
        let spy = SubscriberSpy<Int, Never>()
        let sut = PagingPublisher(upstream: Just([1, 2, 3]))
        sut.receive(subscriber: spy)

        spy.request(.max(1))

        XCTAssertEqual(spy.received.count, 1)
    }
    
    func test_receivesRequestTwoPages_getsBoth() {
        let spy = SubscriberSpy<Int, Never>()
        let upstream = Publishers.Sequence(sequence: Array(repeating: 0, count: 1000)).flatMap{ _ in
            return Just([1, 2, 3])
        }.print("toSUT")
        let sut = PagingPublisher(upstream: upstream)
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
        let sut = PagingPublisher(upstream: upstream)
        sut.print("toSpy").receive(subscriber: spy)

        spy.request(.max(2))
        
        spy.request(.max(2))

        XCTAssertNil(spy.completion)
        XCTAssertEqual(spy.received.count, 4)
    }
    
    func test_upstreamCompletes_completes() {
        let spy = SubscriberSpy<Int, Never>()
        let upstream = Just([1, 2, 3])
        let sut = PagingPublisher(upstream: upstream)
        sut.receive(subscriber: spy)

        spy.request(.max(4))

        XCTAssertNotNil(spy.completion)
        XCTAssertEqual(spy.received.count, 3)
    }
    
    func test_upstreamCompletesWithExtraInBuffer_doesNotComplete() {
        let spy = SubscriberSpy<Int, Never>()
        let upstream = Just([1, 2, 3])
        let sut = PagingPublisher(upstream: upstream)
        sut.receive(subscriber: spy)

        spy.request(.max(2))

        XCTAssertNil(spy.completion)
        XCTAssertEqual(spy.received.count, 2)
    }
    
    func test_upstreamCompletesWithExtraInBuffer_thenEmptiesBuffer_completes() {
        let spy = SubscriberSpy<Int, Never>()
        let upstream = Just([1, 2, 3])
        let sut = PagingPublisher(upstream: upstream)
        sut.receive(subscriber: spy)

        spy.request(.max(2))
        XCTAssertNil(spy.completion)
        spy.request(.max(2))
        XCTAssertNotNil(spy.completion)
        
        XCTAssertEqual(spy.received.count, 3)
    }
}

class SubscriberSpy<Input, Failure: Error>: Subscriber, Cancellable {
    
    func request(_ demand: Subscribers.Demand) {
        subscription?.request(demand)
    }
    
    
    var subscription: Subscription?
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
    }
    
    var received: [Input] = []
    func receive(_ input: Input) -> Subscribers.Demand {
        received.append(input)
        return .none
    }
    
    var completion: Subscribers.Completion<SubscriberSpy.Failure>?
    func receive(completion: Subscribers.Completion<Failure>) {
        self.completion = completion
    }
    
    func cancel() {
        subscription?.cancel()
    }
}

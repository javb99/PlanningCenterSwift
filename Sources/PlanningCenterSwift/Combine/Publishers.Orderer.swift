//
//  Created by Joseph Van Boxtel on 11/18/19.
//

import Foundation
import Combine

extension Publishers {
    struct Orderer<Element, Upstream: Publisher>: Publisher
    where Upstream.Output == (Int, Element) {
        
        typealias Input = (Int,Element)
        typealias Output = Element
        typealias Failure = Upstream.Failure
        
        let upstream: Upstream
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = OrdererSubscription(subscriber: subscriber)
            upstream.receive(subscriber: subscription)
        }
    }
}
extension Publishers.Orderer {
    
    class OrdererSubscription<S: Subscriber, Element>: Combine.Subscription, Subscriber
    where Failure == S.Failure, S.Input == Element {
        
        let subscriber: S
        var upstreamStatus = SubscriptionStatus.awaitingSubscription
        
        let combineIdentifier = CombineIdentifier()
        
        var pendingFromUpstream = Subscribers.Demand.none
        var outstandingDemand = Subscribers.Demand.none
        var buffer = [Int:Element]()
        var nextEmittedIndex: Int = 0
        
        init(subscriber: S) {
            self.subscriber = subscriber
        }
        
        func emitBuffered() -> Subscribers.Demand {
            var newDemand = Subscribers.Demand.none
            while outstandingDemand > .none, let next = buffer[nextEmittedIndex] {
                buffer[nextEmittedIndex] = nil
                newDemand += subscriber.receive(next)
                outstandingDemand -= 1
                nextEmittedIndex += 1
            }
            if buffer.isEmpty, case .terminal = upstreamStatus {
                subscriber.receive(completion: .finished)
            }
            return newDemand
        }
        
        func requestFromUpstream(_ additionalDemand: Subscribers.Demand) {
            outstandingDemand += additionalDemand
            
            outstandingDemand += emitBuffered()
            
            let outOfOrderSoNeedMore = buffer.count == outstandingDemand.max && outstandingDemand > .none
            let shouldWaitForPending = outstandingDemand > pendingFromUpstream + .max(buffer.count)
            if shouldWaitForPending || outOfOrderSoNeedMore, case let .subscribed(upstream) = upstreamStatus {
                let moreNeeded = outstandingDemand-pendingFromUpstream
                pendingFromUpstream += moreNeeded
                upstream.request(moreNeeded)
            }
        }
        
        public func request(_ additionalDemand: Subscribers.Demand) {
            requestFromUpstream(additionalDemand)
        }
        
        func receive(subscription: Subscription) {
            guard case .awaitingSubscription = upstreamStatus else {
                fatalError("Receiving from upstream before subscribed.")
            }
            upstreamStatus = .subscribed(subscription)
            subscriber.receive(subscription: self)
        }
        
        func receive(_ input: (Int, Element)) -> Subscribers.Demand {
            pendingFromUpstream -= 1
            buffer[input.0] = input.1
            let newDemand = emitBuffered()
            requestFromUpstream(newDemand)
            return newDemand
        }
        
        func receive(completion: Subscribers.Completion<Failure>) {
            upstreamStatus = .terminal
            switch completion {
            case let .failure(error):
                subscriber.receive(completion: .failure(error))
            case .finished:
                // Don't finish until buffer is empty.
                if buffer.isEmpty {
                    subscriber.receive(completion: .finished)
                }
            }
        }
        
        func cancel() {
            if case let .subscribed(upstream) = upstreamStatus {
                upstream.cancel()
            }
            upstreamStatus = .terminal
        }
    }
}

//
//  Created by Joseph Van Boxtel on 11/18/19.
//

import Foundation
import Combine

struct PagingPublisher<Element, Upstream: Publisher>: Publisher
where Upstream.Output == [Element]{
    
    typealias Output = Element
    typealias Failure = Upstream.Failure
    
    let pageSize: Int = 100
    let upstream: Upstream
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            
        let inner = PagingSubscription(subscriber: subscriber, pageSize: pageSize)
        upstream.receive(subscriber: inner)
    }
}

extension PagingPublisher {
    
    class PagingSubscription<S: Subscriber, Element>: Combine.Subscription, Subscriber
    where Failure == S.Failure, S.Input == Element {
        
        typealias Input = [Element]
        typealias Element = Output
        
        class LoadTask {
            let cancelable: AnyCancellable
            let elementRange: Range<Int>
            init(cancelable: AnyCancellable, elementRange: Range<Int>) {
                self.cancelable = cancelable
                self.elementRange = elementRange
            }
        }
        
        let subscriber: S
        var upstreamStatus = SubscriptionStatus.awaitingSubscription
        let pageSize: Int
        
        let combineIdentifier = CombineIdentifier()
        
        var outstandingDemand = Subscribers.Demand.none
        var buffer = [Element]()
        
        init(subscriber: S, pageSize: Int) {
            self.subscriber = subscriber
            self.pageSize = pageSize
        }
        
        func emitBuffered() -> Subscribers.Demand {
            var newDemand = Subscribers.Demand.none
            while outstandingDemand > .none && !buffer.isEmpty {
                newDemand += subscriber.receive(buffer.removeFirst())
                outstandingDemand -= 1
            }
            if buffer.isEmpty, case .terminal = upstreamStatus {
                subscriber.receive(completion: .finished)
            }
            return newDemand
        }
        
        func requestFromUpstream(_ additionalDemand: Subscribers.Demand) {
            outstandingDemand += additionalDemand
            
            outstandingDemand += emitBuffered()
            
            if outstandingDemand > .none, case let .subscribed(upstream) = upstreamStatus {
                upstream.request(self.pageCount(forElementCount: additionalDemand))
            }
        }
        
        func pageCount(forElementCount elementCount: Subscribers.Demand) -> Subscribers.Demand {
            if let finiteDemand = outstandingDemand.max {
                var (pageCount, overflow) = finiteDemand.quotientAndRemainder(dividingBy: pageSize)
                if overflow > 0 {
                    pageCount += 1
                }
                return .max(pageCount)
            } else {
                return .unlimited
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
        
        func receive(_ input: [Element]) -> Subscribers.Demand {
            buffer.append(contentsOf: input)
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
            guard case let .subscribed(upstream) = upstreamStatus else {
                fatalError("Receiving from upstream before subscribed.")
            }
            upstream.cancel()
            upstreamStatus = .terminal
        }
    }
}

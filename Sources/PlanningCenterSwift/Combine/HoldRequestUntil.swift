//
//  Created by Joseph Van Boxtel on 12/7/19.
//

import Foundation
import Combine

extension Publisher {
    public func holdRequests<Unlock: Publisher>(untilOutputFrom unlockPublisher: Unlock) -> AnyPublisher<Output, Failure> where Unlock.Failure == Never {

        return HoldRequestUntilPublisher(upstream: self, unlockPub: unlockPublisher).eraseToAnyPublisher()
    }
}

struct HoldRequestUntilPublisher<Upstream, Unlock>: Publisher where Upstream: Publisher, Unlock: Publisher, Unlock.Failure == Never {
    
    typealias Output = Upstream.Output
    typealias Failure = Upstream.Failure
    
    var upstream: Upstream
    var unlockPub: Unlock
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let sub = Sub(unlockPub: unlockPub, downstream: subscriber)
        upstream.receive(subscriber: sub)
        subscriber.receive(subscription: sub)
    }
    
    class Sub<Downstream>: Subscription, Subscriber where Downstream: Subscriber, Downstream.Input == Output, Downstream.Failure == Failure {
        
        var upstreamSub: Subscription?
        var unlockPub: Unlock
        var unlockSub: AnyCancellable?
        var downstream: Downstream
        
        init(unlockPub: Unlock, downstream: Downstream) {
            self.unlockPub = unlockPub
            self.downstream = downstream
        }
        
        var downstreamDemand = Subscribers.Demand.none
        
        var isLocked = true {
            didSet {
                upstreamSub!.request(downstreamDemand)
            }
        }
        
        // Create subscriber on the unlockPublisher
        func requestUnlock() {
            unlockSub = unlockPub.prefix(1).sink {[unowned self] _ in
                self.isLocked = false
            }
        }
        
        // MARK: Subscriber
        // Subscribed to Upstream
        
        typealias Input = Upstream.Output
        
        typealias Failure = Upstream.Failure
        
        func receive(subscription: Subscription) {
            upstreamSub = subscription
            requestUnlock()
        }
        
        func receive(_ input: Input) -> Subscribers.Demand {
            assert(isLocked == false)
            return downstream.receive(input)
        }
        
        func receive(completion: Subscribers.Completion<Failure>) {
            downstream.receive(completion: completion)
        }
        
        // MARK: Subscription
        // Publishes to downstream subscriber
        
        func request(_ demand: Subscribers.Demand) {
            if isLocked == false {
                upstreamSub?.request(demand)
            } else {
                downstreamDemand += demand
            }
        }
        
        func cancel() {
            
        }
        
        var combineIdentifier = CombineIdentifier()
    }
}

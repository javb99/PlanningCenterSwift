//
//  Created by Joseph Van Boxtel on 12/7/19.
//

import Foundation
import Combine

extension Publisher where Failure == Never {
    public func caching() -> AnyPublisher<Output, Failure>{

        return Caching(upstream: self).eraseToAnyPublisher()
    }
}

struct Caching<Upstream>: Publisher where Upstream: Publisher, Upstream.Failure == Never {
    
    typealias Output = Upstream.Output
    typealias Failure = Upstream.Failure
    
    var upstream: Upstream
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let sub = Sub(downstream: subscriber)
        sub.upstreamSub = upstream.assign(to: \Sub<S>.value, on: sub)
        subscriber.receive(subscription: sub)
    }
    
    class Sub<Downstream>: Subscription where Downstream: Subscriber, Downstream.Input == Output, Downstream.Failure == Failure {
        
        var downstream: Downstream
        var upstreamSub: AnyCancellable?
        
        init(downstream: Downstream) {
            self.downstream = downstream
        }
        
        deinit {
            upstreamSub?.cancel()
            upstreamSub = nil
        }
        
        var value: Output! {
            didSet {
                emitIfAppropriate()
            }
        }
        
        var downstreamDemand = Subscribers.Demand.none
        
        func request(_ demand: Subscribers.Demand) {
            downstreamDemand += demand
            emitIfAppropriate()
        }
        
        func cancel() {
            upstreamSub?.cancel()
        }
        
        var combineIdentifier = CombineIdentifier()
        
        func emitIfAppropriate() {
            if let value = value {
                while downstreamDemand > .none {
                    downstreamDemand += downstream.receive(value)
                }
            }
        }
    }
}

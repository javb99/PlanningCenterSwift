//
//  Created by Joseph Van Boxtel on 11/18/19.
//

import Foundation
import Combine

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

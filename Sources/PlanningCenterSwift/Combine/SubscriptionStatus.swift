//
//  Created by Joseph Van Boxtel on 11/18/19.
//

import Foundation
import Combine

enum SubscriptionStatus {
    case awaitingSubscription
    case subscribed(Subscription)
    case terminal
}

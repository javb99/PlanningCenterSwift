//
//  Created by Joseph Van Boxtel on 11/25/19.
//

import Foundation
import Combine

struct FunctionSequence<Element>: Sequence {
    var initial: Element
    var next: (Element)->Element?
    
    __consuming func makeIterator() -> Iterator<Element> {
        return Iterator(nextElement: initial, makeNext: next)
    }
    
    struct Iterator<Element>: IteratorProtocol {
        var nextElement: Element?
        var makeNext: (Element)->Element?
        
        mutating func next() -> Element? {
            if let current = nextElement {
                nextElement = makeNext(current)
                return current
            } else {
                return nil
            }
        }
    }
    
    
}

extension FunctionSequence where Element == Int {
    /// Ascending integers starting at zero.
    static var positiveAscending: Self {
        Self(initial: 0, next: { $0+1 })
    }
}

extension Publishers {
    static var integers: Publishers.Sequence<FunctionSequence<Int>, Never> {
        Publishers.Sequence(sequence: FunctionSequence(initial: 0, next: { $0+1 }))
    }
}

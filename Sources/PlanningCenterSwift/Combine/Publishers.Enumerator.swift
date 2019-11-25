//
//  Created by Joseph Van Boxtel on 11/25/19.
//

import Foundation
import Combine

extension Publisher {
    func enumerated() -> AnyPublisher<(Int, Output), Failure> {
        var index = 0
        return self.map { element -> (Int, Output) in
            defer { index += 1 }
            return (index, element)
        }.eraseToAnyPublisher()
    }
}

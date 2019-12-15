//
//  Created by Joseph Van Boxtel on 12/14/19.
//

import Foundation
import JSONAPISpec

extension Endpoints.Plan {
    
    public var teamPositions: ListEndpoint<Endpoints.NeededPosition> { .init(path: path.appending("needed_positions")) }
}

extension Endpoints {
    
    public struct NeededPosition: SingleResourceEndpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.NeededPosition>
        
        public typealias ResourceType = Models.NeededPosition
        
        public let method: HTTPMethod = .get
        
        public var path: Path

        public init(basePath: Path, id: ResourceIdentifier<Models.NeededPosition>) {
            path = basePath.appending(id.id)
        }
    }
}

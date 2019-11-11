//
//  Created by Joseph Van Boxtel on 11/11/19.
//

import Foundation
import JSONAPISpec

extension Endpoints.PeopleOrganizationEndpoint {
    
    public var me: Endpoints.Me { .init(basePath: path) }
}

extension Endpoints {

    public struct Me: ResourceEndpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.PeoplePerson>
        
        public typealias ResourceType = Models.PeoplePerson
        
        public var method: HTTPMethod = .get
        
        public var path: Path

        public init(basePath: Path) {
            path = basePath.appending("me")
        }
    }
}

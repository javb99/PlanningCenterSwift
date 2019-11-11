//
//  Created by Joseph Van Boxtel on 11/10/19.
//

import Foundation
import JSONAPISpec

extension Endpoints.ServicesOrganizationEndpoint {
    
    public var people: CreatableListEndpoint<Endpoints.Person> { .init(path: path.appending("people")) }
}

extension Endpoints {

    public struct Person: SingleResourceEndpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.Person>
        
        public typealias ResourceType = Models.Person
        
        public var path: Path

        public init(basePath: Path, id: ResourceIdentifier<Models.Person>) {
            path = basePath.appending(id.id)
        }
    }
}

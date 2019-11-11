//
//  Created by Joseph Van Boxtel on 11/10/19.
//

import Foundation
import JSONAPISpec

extension Endpoints {
    public static var services = ServicesOrganizationEndpoint()

    public struct ServicesOrganizationEndpoint: Endpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.Organization>
        
        public typealias ResourceType = Models.Organization
        
        public var path: Path = ["services", "v2"]
    }
}

//
//  Created by Joseph Van Boxtel on 11/11/19.
//

import Foundation
import JSONAPISpec

extension Endpoints.ServiceType {
    
    public var teamPositions: ListEndpoint<Endpoints.PlanPerson> { .init(path: path.appending("team_positions")) }
    
    public var teamPositionsWithTeam: some Endpoint { teamPositions.include(Models.Team.self)
    }
}

extension Endpoints.Team {
    
    public var teamPosition: ListEndpoint<Endpoints.PlanPerson> { .init(path: path.appending("team_positions")) }
}

extension Endpoints.PersonTeamPositionAssignment {
    
    public var teamPosition: Endpoints.TeamPosition { .init(path: path.appending("team_position")) }
}

extension Endpoints {
    
    public struct TeamPosition: ResourceEndpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.TeamPosition>
        
        public typealias ResourceType = Models.TeamPosition
        
        public let method: HTTPMethod = .get
        
        public var path: Path

        public init(path: Path) {
            self.path = path
        }
    }
}

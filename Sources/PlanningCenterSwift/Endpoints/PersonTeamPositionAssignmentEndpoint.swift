//
//  Created by Joseph Van Boxtel on 11/10/19.
//

import Foundation
import JSONAPISpec

// MARK: - PersonTeamPositionAssignment Specific -

extension Endpoints.ServiceType {
    
    public var personTeamPositionAssignments: CreatableListEndpoint<Endpoints.PersonTeamPositionAssignment> { .init(path: path.appending("person_team_position_assignments")) }
}

extension Endpoints.Team {
    
    public var personTeamPositionAssignments: CreatableListEndpoint<Endpoints.PersonTeamPositionAssignment> { .init(path: path.appending("person_team_position_assignments")) }
}

extension Endpoints.Person {

    public var personTeamPositionAssignments: CreatableListEndpoint<Endpoints.PersonTeamPositionAssignment> { .init(path: path.appending("person_team_position_assignments")) }
}

//extension Endpoints.TeamPosition {
//
//    public var personTeamPositionAssignments: CreatableListEndpoint<Endpoints.PlanPerson> { .init(path: path.appending("person_team_position_assignments")) }
//}

// MARK: - Boilerplate -

extension Endpoints {

    public struct PersonTeamPositionAssignment: SingleResourceEndpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.PersonTeamPositionAssignment>
        
        public typealias ResourceType = Models.PersonTeamPositionAssignment
        
        public var path: Path

        public init(basePath: Path, id: ResourceIdentifier<Models.PersonTeamPositionAssignment>) {
            path = basePath.appending(id.id)
        }
    }
}

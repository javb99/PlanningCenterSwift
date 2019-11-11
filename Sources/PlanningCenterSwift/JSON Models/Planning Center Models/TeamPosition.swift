//
//  Created by Joseph Van Boxtel on 11/11/19.
//

import Foundation
import JSONAPISpec

extension Models {
    /// [Planning Center Documentation](https://developer.planning.center/docs/#/apps/services/2018-11-01/vertices/team_position)
    public struct TeamPosition {}
}

extension Models.TeamPosition: ResourceProtocol {

    public struct Attributes: Codable {

        public var name: String

        // TODO: Add tag fields.
    }

    public struct Relationships: Codable {

        enum CodingKeys: String, CodingKey {
            case team
            //case attachmentTypes = "attachment_types"
        }

        public var team: ToOneRelationship<Models.Team>

        //public var attachmentTypes: ToManyRelationship<Models.AttachmentType>
    }

    public typealias Links = Empty

    public typealias Meta = Empty
}

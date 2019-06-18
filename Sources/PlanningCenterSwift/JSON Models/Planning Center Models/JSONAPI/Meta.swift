//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/16/19.
//

import Foundation
import GenericJSON

public struct Meta: JSONDecodable {
    
    public var json: JSON
    
    public init(json: JSON) throws {
        self.json = json
    }
}

extension Meta {
    /// The number of resources that were sent.
    public var count: Int? { return self.json["count"] }
    
    /// The number of resources that are available.
    public var totalCount: Int? { return self.json["total_count"] }
    
    public var canOrderBy: [String]? { return self.json["can_order_by"] }
    public var canQueryBy: [String]? { return self.json["can_query_by"] }
    public var canInclude: [String]? { return self.json["can_include_by"] }
    public var canFilterBy: [String]? { return self.json["can_filter_by"] }
}

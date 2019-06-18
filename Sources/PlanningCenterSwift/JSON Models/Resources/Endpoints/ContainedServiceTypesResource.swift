//
//  ContainedServiceTypesResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/11/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

extension Folder {
    public var serviceTypes: ContainedServiceTypesResource {
        return .init(folderID: id)
    }
}

/// Fetches the `ServiceType`s inside a folder.
public struct ContainedServiceTypesResource: APIResourceType {
    
    public typealias Model = [ServiceType]
    
    public let folderID: ResourceIdentifier<Folder>
    
    public init(folderID: ResourceIdentifier<Folder>) {
        self.folderID = folderID
    }
    
    public var path: String {
        return "folders/\(folderID)/service_types"
    }
}

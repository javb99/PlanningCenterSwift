//
//  FolderEndpoint.swift
//
//
//  Created by Joseph Van Boxtel on 7/27/19.
//

import Foundation
import JSONAPISpec

// MARK: - Folder Specific -

extension Endpoints.Folder {
    
    public var subfolders: ListEndpoint<Endpoints.Folder> { .init(path: path.appending("folders")) }

    public var serviceTypes: ListEndpoint<Endpoints.ServiceType> { .init(path: path.appending("service_types")) }
}

// MARK: - Boilerplate -

extension Endpoints.ServicesOrganizationEndpoint {
    
    public var folders: CRUDEndpoint<Endpoints.Folder> { .init(path: path.appending("folders")) }
}

extension Endpoints {

    public struct Folder: SingleResourceEndpoint {
        
        public typealias RequestBody = Empty
        
        public typealias ResponseBody = ResourceDocument<Models.Folder>
        
        public typealias ResourceType = Models.Folder
        
        public var path: Path

        public init(basePath: Path, id: ResourceIdentifier<Models.Folder>) {
            path = basePath.appending(id.id)
        }
    }
}


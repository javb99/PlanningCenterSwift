//
//  FolderEndpoint.swift
//
//
//  Created by Joseph Van Boxtel on 7/27/19.
//

import Foundation
import JSONAPISpec

extension Endpoints.Folder {
    
    public var subfolders: ListEndpoint<Endpoints.Folder> { .init(path: path.appending("folders")) }

    public var serviceTypes: ListEndpoint<Endpoints.ServiceType> { .init(path: path.appending("service_types")) }
}

extension Endpoints.ServicesOrganizationEndpoint {
    
    public var folders: Filtered<CRUDEndpoint<Endpoints.Folder>, Endpoints.Folder.ParentFilter> {
        Filtered(.init(path: path.appending("folders")))
    }
    
    public var rootFolders: AnyEndpoint<Empty, ResourceCollectionDocument<Models.Folder>> { folders.filter(.root) }
}

extension Endpoints.Folder {
    public enum ParentFilter {
        case root
        case parent(ResourceIdentifier<Models.Folder>)
    }
}

extension Endpoints.Folder.ParentFilter: QueryParamProviding {
    public var queryParams: [URLQueryItem] {
        switch self {
        case .root:
            return [URLQueryItem(name: "where[parent_id]", value: "")]
        case let .parent(identifier):
            return [URLQueryItem(name: "where[parent_id]", value: identifier.id)]
        }
    }
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


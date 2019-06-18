//
//  SubfoldersResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/11/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

extension Folder {
    var subfolders: SubfoldersResource {
        return .init(folderID: id)
    }
}

struct SubfoldersResource: APIResourceType {
    
    typealias Model = [Folder]
    
    let folderID: ResourceIdentifier<Folder>
    
    init(folderID: ResourceIdentifier<Folder>) {
        self.folderID = folderID
    }
    
    var path: String {
        return "folders/\(folderID.id)/folders"
    }
}

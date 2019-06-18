//
//  FoldersResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/11/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

public struct FoldersResource: APIResourceType {
    
    public typealias Model = [Folder]
    
    public init() {}
    
    public var path: String {
        return "folders"
    }
}

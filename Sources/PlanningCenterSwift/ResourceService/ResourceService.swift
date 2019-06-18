//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/17/19.
//

import Foundation

public protocol ResourceService: class {
    func fetch<Resource: NetworkResourceType>(resource: Resource, completion: @escaping (Resource, Result<Resource.Model, Error>)->())
}

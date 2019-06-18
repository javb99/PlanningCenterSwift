//
//  Request.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 1/5/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation
import GenericJSON

/// A resource is a description of how to parse a model from data.
public protocol ResourceType {
    associatedtype Model
    
    func makeModel(_ data: Data) throws -> Model
}

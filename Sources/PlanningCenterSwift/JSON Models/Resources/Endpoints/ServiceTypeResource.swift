//
//  ServiceTypeResource.swift
//  ServicesScheduler
//
//  Created by Joseph Van Boxtel on 4/1/19.
//  Copyright © 2019 Joseph Van Boxtel. All rights reserved.
//

import Foundation

public typealias ServiceTypeResource = SingleResource<ServiceType>

extension ServiceType: FetchableByIdentifier {
    public static var collectionPath: String {
        return "service_types"
    }
}

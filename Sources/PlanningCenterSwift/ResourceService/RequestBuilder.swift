//
//  RequestBuilder.swift
//  
//
//  Created by Joseph Van Boxtel on 9/15/19.
//

import Foundation
import JSONAPISpec

public protocol RequestBuilder {
    func buildRequest<Endpt: Endpoint>(for endpoint: Endpt) -> URLRequest? where Endpt.RequestBody == Empty
    func buildRequest<Endpt: Endpoint>(for endpoint: Endpt, body: Endpt.RequestBody) -> URLRequest?
}

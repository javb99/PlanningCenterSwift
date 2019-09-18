//
//  ResponseHandler.swift
//  
//
//  Created by Joseph Van Boxtel on 9/15/19.
//

import Foundation

public protocol ResponseHandler {
    func handleResponse<Endpt: Endpoint>(to endpoint: Endpt, _ response: URLResponse?, data: Data?, error: Error?)
    -> Result<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError>
}

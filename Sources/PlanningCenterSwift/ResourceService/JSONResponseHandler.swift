//
//  JSONResponseHandler.swift
//  
//
//  Created by Joseph Van Boxtel on 9/15/19.
//

import Foundation
import JSONAPISpec

public class JSONResponseHandler: ResponseHandler {
    
    private let decoder: JSONDecoder
    
    public init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    public func handleResponse<Endpt: Endpoint>(to endpoint: Endpt, _ response: URLResponse?, data: Data?, error: Error?) -> Result<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError> {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noHTTPResponse)
        }
        
        guard httpResponse.statusCode != 401, httpResponse.statusCode != 403 else {
            return .failure(.notAuthorized)
        }
        guard httpResponse.statusCode != 429 else {
            return .failure(.rateLimit)
        }
        guard !(400..<500).contains(httpResponse.statusCode) else {
            return .failure(.client(httpResponse.statusCode))
        }
        guard httpResponse.statusCode < 500 else {
            return .failure(.server(httpResponse.statusCode))
        }
            
        if Endpt.ResponseBody.self == Empty.self {
            // Empty bodies don't need to be parsed.
            return .success((httpResponse, endpoint, Empty() as! Endpt.ResponseBody))
        }
        
        guard let data = data else {
            if let error = error {
                return .failure(.system(error))
            } else {
                return .failure(.unknown)
            }
        }
        let model: Endpt.ResponseBody
        do {
            model = try decoder.decode(Endpt.ResponseBody.self, from: data)
        } catch {
            return .failure(.decode(error))
        }
        
        return .success((httpResponse, endpoint, model))
    }
}

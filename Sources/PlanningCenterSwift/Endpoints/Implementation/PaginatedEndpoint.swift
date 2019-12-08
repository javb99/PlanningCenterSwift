//
//  Created by Joseph Van Boxtel on 11/12/19.
//

import Foundation

extension Endpoint {
    
    public func page(pageNumber: Int = 0, pageSize: Int = 25) -> AnyEndpoint<RequestBody, ResponseBody> {
        return page(offset: pageNumber * pageSize, pageSize: pageSize)
    }
    
    public func page(offset: Int = 0, pageSize: Int = 25) -> AnyEndpoint<RequestBody, ResponseBody> {
        let paginationParams = [
            URLQueryItem(name: "per_page", value: "\(pageSize)"),
            URLQueryItem(name: "offset", value: "\(offset)")]
        return AnyEndpoint(method: self.method, path: self.path, queryParams: self.queryParams + paginationParams)
    }
}

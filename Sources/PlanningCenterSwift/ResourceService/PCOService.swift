//
//  Created by Joseph Van Boxtel on 11/10/19.
//

import Foundation
import JSONAPISpec
import Combine

public typealias Completion<Endpt: Endpoint> = (Result<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError>) -> ()

public typealias PCOService = PCOUploadService & PCODownloadService

public protocol PCOUploadService {
    /// Execute a request for an endpoint that requires a request body.
    func send<Endpt: Endpoint>(
        body: Endpt.RequestBody,
        to endpoint: Endpt,
        completion: @escaping Completion<Endpt>
    )
}

public protocol PCODownloadService {
    /// Execute a request for an endpoint that doesn't require a request body.
    func fetch<Endpt: Endpoint>(
        _ endpoint: Endpt,
        completion: @escaping Completion<Endpt>
    ) where Endpt.RequestBody == JSONAPISpec.Empty
}

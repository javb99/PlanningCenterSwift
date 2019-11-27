//
//  Created by Joseph Van Boxtel on 11/25/19.
//

import Foundation
import Combine
import JSONAPISpec

extension PCODownloadService {
    
    func publisher<Endpt, R>(for endpt: Endpt, pageSize: Int = 25)
        -> AnyPublisher<Resource<R>, NetworkError>
        where Endpt: Endpoint, R: ResourceProtocol,
        Endpt.ResponseBody == ResourceCollectionDocument<R>,
        Endpt.RequestBody == JSONAPISpec.Empty {
        
            let pageNumbers = Publishers.Sequence(sequence: FunctionSequence<Int>.positiveAscending).setFailureType(to: NetworkError.self).print("Upstream")
            
            let pageFutures = pageNumbers.respectfulFlatMap() { pageIndex in
                self.future(for: endpt)
                .map { (_, _, body: ResourceCollectionDocument<R>) -> (Int, [Resource<R>]) in
                    let resources = body.data ?? []
                    return (pageIndex, resources)
                    }.print("Child")
            }.print("Downstream")
            
            let orderedPages = Publishers.Orderer(upstream: pageFutures).print("Order/Paging")
            return PagingPublisher(pageSize: pageSize, upstream: orderedPages)
                .print("EndpointPublisher")
                .eraseToAnyPublisher()
    }
    
    func future<Endpt>(for endpt: Endpt)
    -> Future<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError>
    where Endpt: Endpoint,
    Endpt.RequestBody == JSONAPISpec.Empty {
        
        Future<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError>() { fulfill in
            self.fetch(endpt, completion: fulfill)
        }
    }
}

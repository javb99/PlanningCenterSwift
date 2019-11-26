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
        
            let pageNumbers = Publishers.Sequence(sequence: FunctionSequence<Int>.positiveAscending).setFailureType(to: NetworkError.self).prefix(10).print()
            
            let pageFutures = pageNumbers.respectfulFlatMap(maxPublishers: .max(1)) { pageIndex in
                self.future(for: endpt)
                .map { (_, _, body: ResourceCollectionDocument<R>) -> [Resource<R>] in
                    let resources = body.data ?? []
                    return resources
                }.map {
                    (pageIndex, $0)
                }
            }
            
            let orderedPages = Publishers.Orderer(upstream: pageFutures)
            return orderedPages.flatten()
//            future(for: endpt)
//                .map { (_, _, body: ResourceCollectionDocument<R>) -> [Resource<R>] in
//                    let resources = body.data ?? []
//                    return resources
//                }.flatten()
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

extension Publisher where Output: Collection {
    func flatten() -> AnyPublisher<Output.Element, Failure> {
        self.flatMap {
            Publishers.Sequence(sequence: $0)
        }.eraseToAnyPublisher()
    }
}

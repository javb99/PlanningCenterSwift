//
//  Created by Joseph Van Boxtel on 11/25/19.
//

import Foundation
import Combine
import JSONAPISpec


typealias PagedEndpoint<Endpt: Endpoint> = AnyEndpoint<Endpt.RequestBody, Endpt.ResponseBody>
typealias PagedFuture<Endpt: Endpoint> = Future<(HTTPURLResponse, PagedEndpoint<Endpt>, Endpt.ResponseBody), NetworkError>

extension PCODownloadService {
    
    func publisher<Endpt, R>(for endpt: Endpt, pageSize: Int = 25)
        -> AnyPublisher<Resource<R>, NetworkError>
        where Endpt: Endpoint, R: ResourceProtocol,
        Endpt.ResponseBody == ResourceCollectionDocument<R>,
        Endpt.RequestBody == JSONAPISpec.Empty {
            
            var totalPageCount: Int? = nil
            func setTotalPages(_ elementCount: Int) {
                let pageCount = elementCount.divideRoundingUp(by: pageSize)
                totalPageCount = pageCount
            }
            
            func pageExists(_ pageIndex: Int) -> Bool {
                if pageIndex > 1, let totalPageCount = totalPageCount, pageIndex >= totalPageCount {
                    return false
                }
                return true
            }
            
            let pageIndexes = FunctionSequence<Int>.positiveAscending
            return Publishers.Sequence(sequence: pageIndexes)
                .setFailureType(to: NetworkError.self)
                .prefix(while: pageExists)
                .map { pageIndex in
                    let pageEndpoint = endpt.page(pageNumber: pageIndex, pageSize: pageSize)
                    return self.future(for: pageEndpoint)
                }
            .flatMap(maxPublishers: .max(1)) { (pageFuture: PagedFuture<Endpt>) in
                    return pageFuture.map { (_, _, body: ResourceCollectionDocument<R>) -> [Resource<R>] in
                        if let elementsCount = body.meta?.totalCount {
                            setTotalPages(elementsCount)
                        }
                        return body.data ?? []
                    }
                }.flatten().eraseToAnyPublisher()
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
    func flatten() -> Publishers.FlatMap<Publishers.Sequence<Self.Output, Self.Failure>, Self> {
        flatMap(maxPublishers: .max(1)) {
            Publishers.Sequence<Output, Failure>(sequence: $0)
        }
    }
}

//
//  Created by Joseph Van Boxtel on 11/12/19.
//

import Foundation
import Combine
import JSONAPISpec

/// Parameter: page
typealias ResultHandler<T, E: Error> = (Result<T, E>)->()

public typealias PagedEndpoint<Endpt: Endpoint> = AnyEndpoint<Endpt.RequestBody, Endpt.ResponseBody>
public typealias PagedFuture<Endpt: Endpoint> = AnyPublisher<(HTTPURLResponse, PagedEndpoint<Endpt>, Endpt.ResponseBody), NetworkError>
public typealias EndpointFuture<Endpt: Endpoint> = AnyPublisher<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError>

extension URLSessionService {
    
    public func publisher<Endpt, R>(for endpt: Endpt, pageSize: Int = 25)
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
    
    public func future<Endpt>(for endpoint: Endpt) -> EndpointFuture<Endpt>
    where Endpt: Endpoint, Endpt.RequestBody == JSONAPISpec.Empty {
        let request = requestBuilder.buildRequest(for: endpoint)!
        #warning("this can fail if there is not auth header")
        return session.dataTaskPublisher(for: request)
            .mapError(NetworkError.system)
            .tryMap(errorsAre: NetworkError.self) { arg in
                let (data, response) = arg
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.noHTTPResponse
                }
                let parsedData = self.responseHandler.handleResponse(to: endpoint, httpResponse, data: data, error: nil)
                switch parsedData {
                case let .success(httpResponse, endpoint, body):
                    return (httpResponse, endpoint, body)
                case let .failure(networkError):
                    throw networkError
                }
                
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output: Collection {
    public func flatten() -> Publishers.FlatMap<Publishers.Sequence<Self.Output, Self.Failure>, Self> {
        flatMap(maxPublishers: .max(1)) {
            Publishers.Sequence<Output, Failure>(sequence: $0)
        }
    }
}

extension Publisher {
    /// Use when the all possible thrown errors are a certain error type, E.
    func tryMap<E, T>(errorsAre: E.Type, transform: @escaping (Output) throws -> T) -> Publishers.MapError<Publishers.TryMap<Self, T>, E> where E: Error {
        return tryMap(transform).mapError(forceCast)
    }
}

func forceCast<T>(_ value: Any) -> T {
    return value as! T
}

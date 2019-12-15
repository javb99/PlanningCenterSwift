//
//  Created by Joseph Van Boxtel on 11/12/19.
//

import Foundation
import Combine
import JSONAPISpec

extension URLSessionService: PCOCombineService {
    
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

extension Publisher {
    /// Use when the all possible thrown errors are a certain error type, E.
    func tryMap<E, T>(errorsAre: E.Type, transform: @escaping (Output) throws -> T) -> Publishers.MapError<Publishers.TryMap<Self, T>, E> where E: Error {
        return tryMap(transform).mapError(forceCast)
    }
}

func forceCast<T>(_ value: Any) -> T {
    return value as! T
}

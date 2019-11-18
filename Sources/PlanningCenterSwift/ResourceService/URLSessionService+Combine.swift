//
//  Created by Joseph Van Boxtel on 11/12/19.
//

import Foundation
import Combine
import JSONAPISpec


//struct ListEndpointPublisher<Endpt: ResourceListEndpoint>: Publisher {
//
//    typealias Element = Resource<Endpt.InstanceEndpoint.ResourceType>
//
//    typealias Output = Element
//    typealias Failure = NetworkError
//
//    let endpoint: Endpt
//    let network: PCOService
//
//    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
//
//        let subscription = ListSubscription(subscriber: subscriber) { (pageRange, completion)->AnyCancellable in
//            return AnyCancellable({})
//        }
//        subscriber.receive(subscription: subscription)
//    }
//}

/// Parameter: page
typealias ResultHandler<T, E: Error> = (Result<T, E>)->()

//
//extension URLSessionService {
//
//    //public typealias EndpointPublisher<E: Endpoint> = AnyPublisher<(HTTPURLResponse, E, E.ResponseBody), NetworkError>
//
//    public func publish<Endpt: Endpoint>(_ endpoint: Endpt) -> EndpointPublisher<Endpt> where Endpt.RequestBody == JSONAPISpec.Empty {
//        guard let request = requestBuilder.buildRequest(for: endpoint) else {
//            return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
//        }
//        return publish(request, for: endpoint)
//    }
//
//    public func publish<Endpt: Endpoint>(_ endpoint: Endpt, body: Endpt.RequestBody) -> EndpointPublisher<Endpt> {
//
//        guard let request = requestBuilder.buildRequest(for: endpoint, body: body) else {
//            return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
//        }
//        return publish(request, for: endpoint)
//    }
//
//
//    // MARK: Implementation
//
//    private func publish<Endpt: Endpoint>(_ request: URLRequest, for endpoint: Endpt) -> EndpointPublisher<Endpt> {
//
//        return session.dataTaskPublisher(for: request)
//            .mapError(NetworkError.system)
//            .tryMap(errorsAre: NetworkError.self) { data, response in
//                try self.responseHandler.handleResponse(to: endpoint, response, data: data)
//            }
//            .eraseToAnyPublisher()
//    }
//}
//
//extension Publisher {
//    /// Use when the all possible thrown errors are a certain error type, E.
//    func tryMap<E, T>(errorsAre: E.Type, transform: @escaping (Output) throws -> T) -> Publishers.MapError<Publishers.TryMap<Self, T>, E> where E: Error {
//        return tryMap(transform).mapError(forceCast)
//    }
//}
//
//func forceCast<T>(_ value: Any) -> T {
//    return value as! T
//}

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
            
            let pageNumbers = Publishers.Sequence(
                sequence: FunctionSequence<Int>.positiveAscending
            ).setFailureType(to: Never.self)
            .print("PageSequence")
            
            var totalPageCount: Int? = nil
            
            let pageFutures = pageNumbers
                .setFailureType(to: NetworkError.self)
                .map { pageIndex -> (Int, Future<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError>)? in
                    if pageIndex > 1, let totalPageCount = totalPageCount, pageIndex >= totalPageCount {
                        return nil
                    }
                    return (pageIndex, self.future(for: endpt))
                }
                .prefix(while: { $0 != nil })
                .compactMap{ $0 }
                .flatMap(maxPublishers: .max(1)) { pageIndex, future in
                    future
                    .map { (_, _, body: ResourceCollectionDocument<R>) -> (Int, [Resource<R>]) in
                        if let totalCount = body.meta?.totalCount {
                            let pageCount = totalCount.divideRoundingUp(by: pageSize)
                            totalPageCount = pageCount
                        }
                        let resources = body.data ?? []
                        return (pageIndex, resources)
                    }
            }
            
            let orderedPages = Publishers.Orderer(upstream: pageFutures)
            return PagingPublisher(pageSize: pageSize, upstream: orderedPages)
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

class PageIndexesPublisher: Publisher {
    
    typealias Failure = Never
    typealias Output = Int
    
    @Published var totalPageCount: Int? = nil
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Inner(subscriber: subscriber)
        subscriber.receive(subscription: subscription)
        $totalPageCount
            .first(where: {$0 != nil})
            .map{ $0! }
            .receive(subscriber: subscription)
    }
    
    class Inner<Downstream: Subscriber>: Subscription, Subscriber where Downstream.Input == Int, Downstream.Failure == Never {
        
        typealias Input = Int
        
        typealias Failure = Downstream.Failure
        
        var subscriber: Downstream
        
        init(subscriber: Downstream) {
            self.subscriber = subscriber
        }
        
        var demanded: Subscribers.Demand = .none
        var emitted: Subscribers.Demand = .none
        var isCanceled: Bool = false
        
        var totalPageCount: Int? = nil {
            didSet {
                tryToEmit()
            }
        }
        
        func request(_ demand: Subscribers.Demand) {
            if demanded == .none {
                emit(0)
            }
            demanded += demanded
        }
        
        func tryToEmit() {
            guard !isCanceled else { return }
            guard totalPageCount != nil else {
                return // Don't emit until the page count is set.
            }
            while emitted < demanded {
                emit(emitted.max! + 1)
            }
        }
        
        func emit(_ value: Int) {
            guard !isCanceled else { return }
            emitted += 1
            demanded += subscriber.receive(value)
        }
        
        func cancel() {
            isCanceled = true
        }
        
        // MARK: Subscribe
        
        func receive(subscription: Subscription) {
            subscription.request(.max(1))
        }
        
        func receive(_ input: Int) -> Subscribers.Demand {
            totalPageCount = input
            return .none
        }
        
        func receive(completion: Subscribers.Completion<Downstream.Failure>) {
            
        }
    }
}

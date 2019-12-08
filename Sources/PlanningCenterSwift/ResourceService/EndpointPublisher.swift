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
            let pageContentArrays = Publishers.Sequence(sequence: pageIndexes)
                .setFailureType(to: NetworkError.self)
                .prefix(while: pageExists)
                .map { pageIndex in
                    let pageEndpoint = endpt.page(pageNumber: pageIndex, pageSize: pageSize)
                    return self.future(for: pageEndpoint)
                }
                .flatMap(maxPublishers: .max(1)) { pageFuture in
                    pageFuture
                    .map { (_, _, body: ResourceCollectionDocument<R>) -> [Resource<R>] in
                        if let elementsCount = body.meta?.totalCount {
                            setTotalPages(elementsCount)
                        }
                        return body.data ?? []
                    }
                }
            return pageContentArrays.flatten().eraseToAnyPublisher()
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

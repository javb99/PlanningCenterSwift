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
            
            let pageIndexes =  FunctionSequence<Int>.positiveAscending
            let totalPageCountSubject = PassthroughSubject<Int?, Never>()
            //let unlockPub = totalPageCountSubject.compactMap{$0}
            let pageNumbers = Publishers.Sequence(
                sequence: pageIndexes.dropFirst()
            )
            .print("PageSequence")
            .zip(
                totalPageCountSubject
                    .print("CountSubject")
                    .caching()
                    .print("Under Cache")
                    .first(where: {_ in false })
                    .compactMap{$0}
                    .print("MaxPages")
            )
            //.print("Upstream of holdRequests")
            //.holdRequests(untilOutputFrom: unlockPub.print("Unlock2"))
            .print("BeforePrefix")
            .prefix(while: { index, countAvailable in
                // Don't fetch more pages than available.
                index < countAvailable
            })
            .map(\.0)
            .merge(with: Just(0))
            //.prepend(0)
            .print("Upstream")
                
            
            let pageFutures = pageNumbers
                .setFailureType(to: NetworkError.self)
                .respectfulFlatMap() { pageIndex in
                    self.future(for: endpt)
                    .map { (_, _, body: ResourceCollectionDocument<R>) -> (Int, [Resource<R>]) in
                        if let totalCount = body.meta?.totalCount {
                            let pageCount = totalCount.divideRoundingUp(by: pageSize)
                            print("will send pageCount: \(pageCount)")
                            totalPageCountSubject.send(pageCount)
                            print("did send pageCount: \(pageCount)")
                        } else {
                            print("will send pageCount completion")
                            totalPageCountSubject.send(completion: .finished)
                        }
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

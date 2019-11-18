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


struct PagingPublisher<Element, Upstream: Publisher>: Publisher
where Upstream.Output == [Element]{
    
    typealias Output = Element
    typealias Failure = Upstream.Failure
    
    let pageSize: Int = 100
    let upstream: Upstream
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            
        let inner = PagingSubscription(subscriber: subscriber, pageSize: pageSize)
        upstream.receive(subscriber: inner)
    }
}

enum SubscriptionStatus {
    case awaitingSubscription
    case subscribed(Subscription)
    case terminal
}

extension PagingPublisher {
    
    class PagingSubscription<S: Subscriber, Element>: Combine.Subscription, Subscriber
    where Failure == S.Failure, S.Input == Element {
        
        typealias Input = [Element]
        typealias Element = Output
        
        class LoadTask {
            let cancelable: AnyCancellable
            let elementRange: Range<Int>
            init(cancelable: AnyCancellable, elementRange: Range<Int>) {
                self.cancelable = cancelable
                self.elementRange = elementRange
            }
        }
        
        let subscriber: S
        var upstreamStatus = SubscriptionStatus.awaitingSubscription
        let pageSize: Int
        
        let combineIdentifier = CombineIdentifier()
        
        var outstandingDemand = Subscribers.Demand.none
        var buffer = [Element]()
        
        init(subscriber: S, pageSize: Int) {
            self.subscriber = subscriber
            self.pageSize = pageSize
        }
        
        func emitBuffered() -> Subscribers.Demand {
            var newDemand = Subscribers.Demand.none
            while outstandingDemand > .none && !buffer.isEmpty {
                newDemand += subscriber.receive(buffer.removeFirst())
                outstandingDemand -= 1
            }
            if buffer.isEmpty, case .terminal = upstreamStatus {
                subscriber.receive(completion: .finished)
            }
            return newDemand
        }
        
        func requestFromUpstream(_ additionalDemand: Subscribers.Demand) {
            outstandingDemand += additionalDemand
            
            outstandingDemand += emitBuffered()
            
            if outstandingDemand > .none, case let .subscribed(upstream) = upstreamStatus {
                upstream.request(self.pageCount(forElementCount: additionalDemand))
            }
        }
        
        func pageCount(forElementCount elementCount: Subscribers.Demand) -> Subscribers.Demand {
            if let finiteDemand = outstandingDemand.max {
                var (pageCount, overflow) = finiteDemand.quotientAndRemainder(dividingBy: pageSize)
                if overflow > 0 {
                    pageCount += 1
                }
                return .max(pageCount)
            } else {
                return .unlimited
            }
        }
        
        public func request(_ additionalDemand: Subscribers.Demand) {
            requestFromUpstream(additionalDemand)
        }
        
        func receive(subscription: Subscription) {
            guard case .awaitingSubscription = upstreamStatus else {
                fatalError("Receiving from upstream before subscribed.")
            }
            upstreamStatus = .subscribed(subscription)
            subscriber.receive(subscription: self)
        }
        
        func receive(_ input: [Element]) -> Subscribers.Demand {
            buffer.append(contentsOf: input)
            let newDemand = emitBuffered()
            requestFromUpstream(newDemand)
            return newDemand
        }
        
        func receive(completion: Subscribers.Completion<Failure>) {
            upstreamStatus = .terminal
            switch completion {
            case let .failure(error):
                subscriber.receive(completion: .failure(error))
            case .finished:
                // Don't finish until buffer is empty.
                if buffer.isEmpty {
                    subscriber.receive(completion: .finished)
                }
            }
        }
        
        func cancel() {
            guard case let .subscribed(upstream) = upstreamStatus else {
                fatalError("Receiving from upstream before subscribed.")
            }
            upstream.cancel()
            upstreamStatus = .terminal
        }
    }
}

extension PagingPublisher {
    
    class PagingSubscription2<S: Subscriber, Element>: Combine.Subscription
    where Failure == S.Failure, S.Input == Element {
        
        typealias Element = Output
        
        class LoadTask {
            let cancelable: AnyCancellable
            let elementRange: Range<Int>
            init(cancelable: AnyCancellable, elementRange: Range<Int>) {
                self.cancelable = cancelable
                self.elementRange = elementRange
            }
        }
        
        let subscriber: S
        let pageSize: Int
        let getNextPage: (Range<Int>, ResultHandler<[Element], S.Failure>)->AnyCancellable
        let combineIdentifier: CombineIdentifier
        
        var totalEmitted: Int = 0
        var activeLoadTasks: [LoadTask] = []
        var resultsBuffer: [Element] = []
        
        init(subscriber: S, pageSize: Int, getNextPage: @escaping (Range<Int>, ResultHandler<[Element], S.Failure>)->AnyCancellable) {
            self.subscriber = subscriber
            self.pageSize = pageSize
            self.getNextPage = getNextPage
            self.combineIdentifier = .init()
        }
        
        var lastQueuedElement: Int {
            if let lastLoading = activeLoadTasks.last?.elementRange.upperBound {
                return lastLoading
            } else {
                return resultsBuffer.count
            }
        }
        
        var totalDemanded: Subscribers.Demand = .none {
            didSet {
                totalDemandChanged()
            }
        }
        
        var remainingDemand: Subscribers.Demand {
            if let finiteTotalDemand = totalDemanded.max {
                return .max(finiteTotalDemand - totalEmitted)
            } else {
                return .unlimited
            }
        }
        
        public func request(_ additionalDemand: Subscribers.Demand) {
            totalDemanded += additionalDemand
        }
        
        var isAppropriateToEmit: Bool {
            remainingDemand > .none && resultsBuffer.count > 0
        }
        
        func emit() {
            while isAppropriateToEmit {
                #warning("This is O(n)...")
                let next = resultsBuffer.removeFirst()
                totalEmitted += 1
                totalDemanded += subscriber.receive(next)
            }
        }
        
        func fail(_ error: S.Failure) {
            subscriber.receive(completion: .failure(error))
        }
        
        public func cancel() {
            activeLoadTasks.forEach { $0.cancelable.cancel() }
            activeLoadTasks.removeAll()
            subscriber.receive(completion: .finished)
        }
        
        private func totalDemandChanged() {
            // could go down due to emit
            // could go up by request or emit
            
            guard totalDemanded > .none else {
                // nothing more requested.
                return
            }
            
            if isAppropriateToEmit  {
                // some elements are ready return one.
                emit()
                return
            }
            
            if activeLoadTasks.isEmpty {
                // none coming so start some
                beginNewRequestsToCoverDemand()
                return
            }
            // Revaluate after the load tasks complete.
            
//            if lastQueuedElement < totalDemanded {
//                // some coming but not enough
//                beginNewRequestsToCoverDemand()
//                return
//            } else {
//                // current requests cover the demand upon completion.
//                return
//            }
        }
        
        private func beginNewRequestsToCoverDemand() {
            let pageRange = nextPageRange
            
            let cancelable = self.getNextPage(pageRange) { [unowned self] result in
                self.pageLoadCompleted(for: pageRange, result)
            }
            let task = LoadTask(cancelable: cancelable, elementRange: pageRange)
            activeLoadTasks.append(task)
        }
        
        private var nextPageRange: Range<Int> {
            let start = lastQueuedElement
            let maxEnd = start + pageSize
            if let finiteDemand = totalDemanded.max {
                return start..<finiteDemand
            } else {
                return start..<maxEnd
            }
        }
        
        private func pageLoadCompleted(for pageRange: Range<Int>, _ result: Result<[Element], S.Failure>) {
            switch result {
            case let .success(elements):
                resultsBuffer.append(contentsOf: elements)
                if isAppropriateToEmit {
                    emit()
                }
            case let .failure(error):
                fail(error)
            }
            activeLoadTasks.removeAll { $0.elementRange == pageRange }
        }
    }
}

extension Range where Bound == Subscribers.Demand {
    var asFinite: Range<Int>? {
        guard let upper = upperBound.max, let lower = lowerBound.max else {
            return nil
        }
        return lower..<upper
    }
}

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

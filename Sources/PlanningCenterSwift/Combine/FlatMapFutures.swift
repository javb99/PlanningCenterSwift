//
//  FlatMapFutures.swift
//  PlanningCenterSwift
//
//  Created by Joseph Van Boxtel on 11/25/19.
//
//
//  Publishers.FlatMap.swift
//
//  Created by Eric Patey on 16.08.2019.
//

import Foundation
import Combine

extension Publisher {
    /// Transforms all elements from an upstream publisher into a new or existing
    /// publisher.
    ///
    /// `flatMap` merges the output from all returned publishers into a single stream of
    /// output.
    ///
    /// - Parameters:
    ///   - maxPublishers: The maximum number of publishers produced by this method.
    ///   - transform: A closure that takes an element as a parameter and returns a
    ///     publisher that produces *an element* of the return type.
    /// - Returns: A publisher that transforms elements from an upstream publisher into
    ///   a publisher of that element’s type.
    public func flatMapFutures<Result, Child: Publisher>(
        _ transform: @escaping (Output) -> Child
    ) -> Publishers.FlatMapFutures<Child, Self>
        where Result == Child.Output, Failure == Child.Failure {
            return .init(upstream: self,
                         transform: transform)
    }
}

extension Publishers {
    public struct FlatMapFutures<Child: Publisher, Upstream: Publisher>: Publisher
        where Child.Failure == Upstream.Failure
    {
        public typealias Output = Child.Output

        public typealias Failure = Upstream.Failure

        public let upstream: Upstream

        public let transform: (Upstream.Output) -> Child

        public init(upstream: Upstream,
                    transform: @escaping (Upstream.Output) -> Child) {
            self.upstream = upstream
            self.transform = transform
        }
        public func receive<Downstream: Subscriber>(subscriber: Downstream)
            where Child.Output == Downstream.Input, Upstream.Failure == Downstream.Failure
        {
            let inner = Inner(downstream: subscriber,
                              map: transform)
            upstream.subscribe(inner)
            subscriber.receive(subscription: inner)
        }
    }
}

extension Publishers.FlatMapFutures {
    private final class Inner<Downstream: Subscriber>
        : Subscriber,
          Subscription,
          CustomStringConvertible,
          CustomReflectable,
          CustomPlaygroundDisplayConvertible
        where Downstream.Input == Child.Output, Downstream.Failure == Upstream.Failure
    {
        typealias Input = Upstream.Output
        typealias Failure = Upstream.Failure

        private typealias SubscriptionIndex = Int

        /// All requests to this subscription should be made with the `outerLock`
        /// acquired.
        private var outerSubscription: Subscription?

        // Must be recursive lock. Probably a bug in Combine.
        /// The lock for requesting from `outerSubscription`.
        private let outerLock = NSRecursiveLock() //UnfairLock.allocate()

        /// The lock for modifying the state. All mutable state here should be
        /// read and modified with this lock acquired.
        /// The only exception is the `downstreamRecursive` field, which is guarded
        /// by the `downstreamLock`.
        private let lock = NSRecursiveLock()// UnfairLock.allocate()

        // Must be recursive lock. Probably a bug in Combine.
        /// All the calls to the downstream subscriber should be made with this lock
        /// acquired.
        private let downstreamLock = NSRecursiveLock()// UnfairLock.allocate()

        private let downstream: Downstream

        private var downstreamDemand = Subscribers.Demand.none

        /// This variable is set to `true` whenever we call `downstream.receive(_:)`,
        /// and then set back to `false`.
        private var downstreamRecursive = false
        
        private var isWaitingForChild = false
        private var pendingFromChild = Subscribers.Demand.none

        private var innerRecursive = false
        private var childSubscription: Subscription?
        private let map: (Input) -> Child
        private var cancelledOrCompleted = false
        private var outerFinished = false

        init(downstream: Downstream,
             map: @escaping (Upstream.Output) -> Child) {
            self.downstream = downstream
            self.map = map
        }

        deinit {
//            outerLock.deallocate()
//            lock.deallocate()
//            downstreamLock.deallocate()
        }

        // MARK: - Subscriber

        /// Upstream(outer) subscription
        fileprivate func receive(subscription: Subscription) {
            lock.lock()
            guard outerSubscription == nil, !cancelledOrCompleted else {
                lock.unlock()
                subscription.cancel()
                return
            }
            outerSubscription = subscription
            lock.unlock()
        }

        /// Receive upstream input to convert to publisher
        fileprivate func receive(_ input: Upstream.Output) -> Subscribers.Demand {
            lock.lock()
            let cancelledOrCompleted = self.cancelledOrCompleted
            lock.unlock()
            if cancelledOrCompleted {
                return .none
            }
            assert(childSubscription == nil) // Only one child at a time.
            let child = map(input)
            child.receive(subscriber: Side(inner: self))
            return .none
        }

        /// Upstream completed. No more publishers for children.
        fileprivate func receive(completion: Subscribers.Completion<Child.Failure>) {
            outerSubscription = nil
            lock.lock()
            outerFinished = true
            switch completion {
            case .finished:
                releaseLockThenSendCompletionDownstreamIfNeeded(outerFinished: true)
                return
            case .failure:
                let wasAlreadyCancelledOrCompleted = cancelledOrCompleted
                cancelledOrCompleted = true
                self.childSubscription?.cancel()
                self.childSubscription = nil
                lock.unlock()
                if wasAlreadyCancelledOrCompleted {
                    return
                }
                downstreamLock.lock()
                downstream.receive(completion: completion)
                downstreamLock.unlock()
            }
        }

        // MARK: - Subscription
        
        func emitDownstream(_ value: Child.Output) -> Subscribers.Demand {
            downstreamLock.lock()
            downstreamRecursive = true
            assert(downstreamDemand > 0)
            downstreamDemand -= 1
            let additionalDemand = downstream.receive(value)
            downstreamRecursive = false
            downstreamLock.unlock()
            return additionalDemand
        }
        
        // Downstream subscribes
        
        // Downstream demands n
        // Demand 1 pub(child) from upstream
        
        // Recieve 1 pub(child) from upstream
        // Demand n from child
        
        // Receive from child
        // Emit to Downstream

        /// Request coming from downstream.
        fileprivate func request(_ demand: Subscribers.Demand) {
            assert(demand > 0)
            
            lock.lock()
            assert(demand != .unlimited)
            assert(downstreamDemand != .unlimited)
            downstreamDemand += demand
            if let childSubscription = childSubscription {
                // request from child
                requestFromChild(demand)
            } else if isWaitingForChild {
                // do nothing until child comes.
            } else {
                // request child
                requestOneMorePublisher()
            }
            releaseLockThenSendCompletionDownstreamIfNeeded(outerFinished: outerFinished)
        }

        fileprivate func cancel() {
            lock.lock()
            cancelledOrCompleted = true
            let subscription = self.childSubscription
            self.childSubscription = nil
            lock.unlock()
            subscription?.cancel()
            // Combine doesn't acquire the lock here. Weird.
            outerSubscription?.cancel()
            outerSubscription = nil
        }
        
        func requestFromChild(_ demand: Subscribers.Demand) {
            guard demand > 0 else { return }
            if let childSubscription = childSubscription {
                pendingFromChild += demand
                childSubscription.request(demand)
            }
        }

        // MARK: - Reflection

        fileprivate var description: String { return "RespectfulFlatMap" }

        fileprivate var customMirror: Mirror {
            return Mirror(self, children: EmptyCollection())
        }

        fileprivate var playgroundDescription: Any { return description }

        // MARK: - Private

        /// Receive Child subscription
        private func receiveInner(subscription: Subscription) {
            lock.lock()
            isWaitingForChild = false
            childSubscription = subscription

            let demand = downstreamDemand

            lock.unlock()
            requestFromChild(demand)
        }

        /// Receive from child
        private func receiveInner(_ input: Child.Output) -> Subscribers.Demand {
            lock.lock()
            assert(downstreamDemand > 0)
            assert(pendingFromChild > 0)
            pendingFromChild -= 1
            let newDemand = emitDownstream(input)
            requestFromChild(newDemand)
            lock.unlock()
            return .none
        }

        private func receiveInner(completion: Subscribers.Completion<Child.Failure>) {
            switch completion {
            case .finished:
                lock.lock()
                childSubscription = nil
                let downstreamCompleted = releaseLockThenSendCompletionDownstreamIfNeeded(
                    outerFinished: outerFinished
                )
                if !downstreamCompleted && downstreamDemand > 0 && !isWaitingForChild && childSubscription == nil {
                    requestOneMorePublisher()
                }
            case .failure:
                lock.lock()
                if cancelledOrCompleted {
                    lock.unlock()
                    return
                }
                cancelledOrCompleted = true
                self.childSubscription = nil
                lock.unlock()
                downstreamLock.lock()
                downstream.receive(completion: completion)
                downstreamLock.unlock()
            }
        }

        private func requestOneMorePublisher() {
            lock.lock()
            isWaitingForChild = true
            pendingFromChild = .none
            lock.unlock()
            outerLock.lock()
            // Only need one publisher at a time.
            outerSubscription!.request(.max(1))
            outerLock.unlock()
        }

        /// - Precondition: `lock` is acquired
        /// - Postcondition: `lock` is released
        ///
        /// - Returns: `true` if a completion was sent downstream
        @discardableResult
        private func releaseLockThenSendCompletionDownstreamIfNeeded(
            outerFinished: Bool
        ) -> Bool {
            if !cancelledOrCompleted && outerFinished &&
                (childSubscription == nil) && !isWaitingForChild {
                cancelledOrCompleted = true
                lock.unlock()
                downstreamLock.lock()
                downstream.receive(completion: .finished)
                downstreamLock.unlock()
                return true
            }

            lock.unlock()
            return false
        }

        // MARK: - Side

        private struct Side: Subscriber,
                             CustomStringConvertible,
                             CustomReflectable,
                             CustomPlaygroundDisplayConvertible {
            
            private let inner: Inner
            fileprivate let combineIdentifier = CombineIdentifier()

            fileprivate init(inner: Inner) {
                self.inner = inner
            }

            fileprivate func receive(subscription: Subscription) {
                inner.receiveInner(subscription: subscription)
            }

            fileprivate func receive(_ input: Child.Output) -> Subscribers.Demand {
                return inner.receiveInner(input)
            }

            fileprivate func receive(completion: Subscribers.Completion<Child.Failure>) {
                inner.receiveInner(completion: completion)
            }

            fileprivate var description: String { return "RespectfulFlatMap" }

            fileprivate var customMirror: Mirror {
                let children = CollectionOfOne<Mirror.Child>(
                    ("parentSubscription", inner.combineIdentifier)
                )
                return Mirror(self, children: children)
            }

            fileprivate var playgroundDescription: Any { return description }
        }
    }
}

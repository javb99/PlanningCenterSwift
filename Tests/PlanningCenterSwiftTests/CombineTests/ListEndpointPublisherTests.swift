//
//  Created by Joseph Van Boxtel on 11/25/19.
//

import Foundation
import Combine
import XCTest
import JSONAPISpec
@testable import PlanningCenterSwift

class ListEndpointPublisherTests: XCTestCase {
    
    func test_flatMapRespectsDemand() {
        var upstreamRequested = Subscribers.Demand.none
        let upstream = Publishers.Sequence(sequence: FunctionSequence<Int>.positiveAscending)
            .setFailureType(to: Never.self)
            .handleEvents(receiveRequest: { demand in
                upstreamRequested += demand
            })
        let sut = upstream.respectfulFlatMap { int in
            Just(int)
        }
        let spy = SubscriberSpy<Int, Never>()
        sut.receive(subscriber: spy)
        
        spy.request(.max(3))
        XCTAssertNil(spy.completion)
        XCTAssertEqual(spy.received, [0, 1, 2])
        XCTAssertEqual(upstreamRequested, .max(3))
    }
    
    func test_demandsFirstItem_requestsFirstPage() {
        let endpt = Endpoints.services.folders
        let loader = makeMockLoader(for: endpt, pageCount: 1)
        let sut = loader.publisher(for: endpt)
        let spy = SubscriberSpy<Resource<Models.Folder>, NetworkError>()
        sut.receive(subscriber: spy)

        spy.request(.max(1))

        XCTAssertEqual(loader.requestedCount, 1)
    }
    
    func test_demandsTwoPages_getsBoth() {
        let endpt = Endpoints.services.folders
        let loader = makeMockLoader(for: endpt, pageCount: 2)
        let sut = loader.publisher(for: endpt, pageSize: 4)
        let spy = SubscriberSpy<Resource<Models.Folder>, NetworkError>()
        sut.receive(subscriber: spy)

        spy.request(.max(5))

        XCTAssertEqual(loader.requestedCount, 2)
        XCTAssertEqual(spy.received.count, 5)
    }
    
    func test_respectfulFlatMap_upstreamCompletes_completes() {
        var upstreamRequested = Subscribers.Demand.none
        let upstream = Publishers.Sequence(sequence: [0, 1])
            .setFailureType(to: Never.self)
            .handleEvents(receiveRequest: { demand in
                upstreamRequested += demand
            })
        let sut = upstream.print("Upstream").respectfulFlatMap { int in
            Just(int)
        }
        let spy = SubscriberSpy<Int, Never>()
        sut.receive(subscriber: spy)
        
        spy.request(.max(10))
        
        XCTAssertNotNil(spy.completion)
        XCTAssertEqual(spy.received, [0, 1])
    }
    
    func test_demandsFourPages_threeAvailable_getsThreeAndCompletion() {
        let endpt = Endpoints.services.folders
        let loader = makeMockLoader(for: endpt, pageCount: 3)
        let sut = loader.publisher(for: endpt, pageSize: 4)
        let spy = SubscriberSpy<Resource<Models.Folder>, NetworkError>()
        sut.receive(subscriber: spy)

        spy.request(.max(15))

        XCTAssertNotNil(spy.completion)
        XCTAssertEqual(loader.requestedCount, 3)
        XCTAssertEqual(spy.received.count, 12)
    }
}

// MARK: Helpers

func ==<A, B>(_ lhs: (A, B), _ rhs: (A, B)) -> Bool where A: Equatable, B: Equatable {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

let folderA = Resource<Models.Folder>(identifer: "10", attributes: .init(name: "STUDENTS", createdAt: Date(), updatedAt: Date(), container: nil))
let stubFolders = [folderA, folderA, folderA, folderA]

func stubFoldersResponse(pageCount: Int = 1) -> ResourceCollectionDocument<Models.Folder> {
    ResourceCollectionDocument<Models.Folder>(data: stubFolders, meta: CountMeta(totalCount: stubFolders.count*pageCount, count: stubFolders.count))
}
typealias TestEndpoint = Filtered<CRUDEndpoint<Endpoints.Folder>, Endpoints.Folder.ParentFilter>
func makeMockLoader(for endpoint: TestEndpoint, pageCount: Int = 1) -> MockDownloader<PagedEndpoint<TestEndpoint>>  {
    
    MockDownloader{ (_, completion) in
        
        completion(.success((HTTPURLResponse(), endpoint.page(pageNumber: -1, pageSize: -1), stubFoldersResponse(pageCount: pageCount))))
    }
}

extension Resource: CustomStringConvertible where Type == Models.Folder {
    public var description: String {
        self.name ?? "Unnamed folder"
    }
}

class MockDownloader<E>: PCOCombineService where E : Endpoint, E.RequestBody == JSONAPISpec.Empty {
    internal init(respond: @escaping (E, @escaping Completion<E>) -> Void = { _,_  in }) {
        self.respond = respond
    }
    
    var requestedCount: Int = 0
    
    var respond: (E, @escaping Completion<E>) -> Void
    
    func future<Endpt>(for endpoint: Endpt) -> AnyPublisher<(HTTPURLResponse, Endpt, Endpt.ResponseBody), NetworkError> where Endpt : Endpoint, Endpt.RequestBody == JSONAPISpec.Empty {
        
        requestedCount += 1
        
        return Future() { promise in
            print(type(of: promise))
            print(String(describing: Completion<E>.self))
            self.respond(endpoint as! E, promise as! Completion<E>)
        }.eraseToAnyPublisher()
    }
}

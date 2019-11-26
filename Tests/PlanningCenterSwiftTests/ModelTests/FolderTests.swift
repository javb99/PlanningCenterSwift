//
//  FolderTests.swift
//  
//
//  Created by Joseph Van Boxtel on 9/18/19.
//

import XCTest
import JSONAPISpec
import PlanningCenterSwift

final class FolderTests: XCTestCase {
    
    func test_decode_full_success() {
        let folder: Resource<Models.Folder> = try! decode(FolderJSON.full)
        
        XCTAssertEqual(folder.identifer.id, "709999")
        XCTAssertEqual(folder.name, "Vancouver - STUDENTS Ministry")
        XCTAssertEqual(folder.container, "VANCOUVER - Ministry Gatherings")
        XCTAssertNotNil(folder.createdAt)
        XCTAssertNotNil(folder.updatedAt)
        
        XCTAssertEqual(folder.parent?.data?.id, "700011")
        XCTAssertNotNil(folder.ancestors)
        let ancestorIDs = folder.ancestors?.data?.compactMap{$0.id}
        XCTAssertTrue(ancestorIDs!.contains("700011"))
    }
    
    func test_decode_minimumFields_success() {
        let folder: Resource<Models.Folder> = try! decode(FolderJSON.minimumFields)
        
        XCTAssertEqual(folder.identifer.id, "709999")
        XCTAssertNotNil(folder.createdAt)
        
        XCTAssertNil(folder.parent)
        XCTAssertNil(folder.container)
        XCTAssertNil(folder.name)
        XCTAssertNil(folder.updatedAt)
    }
}

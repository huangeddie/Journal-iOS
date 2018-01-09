//
//  JournalTests.swift
//  JournalTests
//
//  Created by Edward Huang on 1/7/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import XCTest
import CoreData
@testable import Journal

class JournalTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        // Reset the store
        let psc = PersistentService.persistentContainer.persistentStoreCoordinator
        let stores = psc.persistentStores
        print("Number of stores: \(stores.count)")
        let store = stores.first!
        let storeURL = psc.url(for: store)
        
        let context = PersistentService.context
        XCTAssert(context.persistentStoreCoordinator === psc)
        
        do {
            try FileManager.default.removeItem(at: storeURL)
            let _ = try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            print(error)
        }
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}

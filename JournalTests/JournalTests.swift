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
        
        // Wipe everything
        JournalLibrarian.WIPE_EVERYTHING()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetupData() {
        XCTAssertEqual(1, JournalLibrarian.numberOfJournals())
        XCTAssertEqual(0, EntryHistorian.numberOfEntries())
    }
    
    func testDefaultJournal() {
        let journal = JournalLibrarian.getCurrentJournal()
        
        XCTAssertEqual(0, journal.id)
        XCTAssertEqual("Journal", journal.name)
        
        XCTAssertEqual(0, EntryHistorian.numberOfEntries())
        
        XCTAssertEqual(1, JournalLibrarian.numberOfJournals())
    }
    
    func testAddJournal() {
        XCTAssertEqual(1, JournalLibrarian.numberOfJournals())
        
        let defaultJournal = JournalLibrarian.getCurrentJournal()
        
        XCTAssertEqual(1, JournalLibrarian.numberOfJournals())
        
        JournalLibrarian.addJournal(name: "Dream")
        
        XCTAssertEqual(2, JournalLibrarian.numberOfJournals())
    }
    
    func testDeleteEntry() {
        EntryHistorian.addEntry(title: "Hello", text: "World", date: Date())
        XCTAssertEqual(1, EntryHistorian.numberOfEntries())
        
        EntryHistorian.deleteEntry(atIndex: 0)
        
        XCTAssertEqual(0, EntryHistorian.numberOfEntries())
    }
    
    func testDeleteDefaultJournal() {
        EntryHistorian.addEntry(title: "Hello", text: "World", date: Date())
        XCTAssertEqual(1, EntryHistorian.numberOfEntries())
        
        JournalLibrarian.deleteJournal(atIndex: 0)
        
        XCTAssertEqual(1, JournalLibrarian.numberOfJournals())
        
        XCTAssertEqual(0, EntryHistorian.numberOfEntries())
    }
    
    func testDeleteJournal() {
        JournalLibrarian.addJournal(name: "Dream")
        XCTAssertEqual(2, JournalLibrarian.numberOfJournals())
        
        JournalLibrarian.deleteJournal(atIndex: 0)
        
        XCTAssertEqual(1, JournalLibrarian.numberOfJournals())
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}

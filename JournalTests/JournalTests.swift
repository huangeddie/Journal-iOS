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
    let journalLibrarian = JournalLibrarian.librarian
    let entryHistorian = EntryHistorian.historian
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Wipe everything
        let context = PersistentService.context
        let journalFetchRequest = NSFetchRequest<Journal>.init(entityName: Journal.description())
        do {
            let searchResults = try context.fetch(journalFetchRequest)
            
            for journal in searchResults {
                context.delete(journal)
            }
            PersistentService.saveContext()
        } catch {
            print(error)
            XCTFail("Something happened when fetching journals")
        }
        
        journalLibrarian.update()
        entryHistorian.update()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        
        
    }
    
    func testSetupData() {
        XCTAssertEqual(1, journalLibrarian.numberOfJournals())
        XCTAssertEqual(0, entryHistorian.numberOfEntries())
    }
    
    func testDefaultJournal() {
        let journal = journalLibrarian.getCurrentJournal()
        
        XCTAssertEqual(0, journal.id)
        XCTAssertEqual("Journal", journal.name)
        
        XCTAssertEqual(0, entryHistorian.numberOfEntries())
        
        XCTAssertEqual(1, journalLibrarian.numberOfJournals())
    }
    
    func testAddJournal() {
        XCTAssertEqual(1, journalLibrarian.numberOfJournals())
        
        let defaultJournal = journalLibrarian.getCurrentJournal()
        
        XCTAssertEqual(1, journalLibrarian.numberOfJournals())
        
        journalLibrarian.addJournal(name: "Dream")
        
        XCTAssertEqual(2, journalLibrarian.numberOfJournals())
    }
    
    func testDeleteEntry() {
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}

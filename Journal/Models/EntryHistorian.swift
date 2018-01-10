//
//  EntryHistorian.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation
import CoreData

/// Singleton Class
class EntryHistorian {
    // MARK: Properties
    static let historian = EntryHistorian(timeFrame: .week)
    
    var timeFrame: TimeFrame {
        didSet {
            updateEntries()
        }
    }
    
    private var entries: [Entry] = []
    
    // MARK: Initialization
    private init(timeFrame: TimeFrame) {
        self.timeFrame = timeFrame
        updateEntries()
    }
    
    // MARK: Public
    func getEntry(for index: Int) -> Entry {
        guard index < entries.count else {
            fatalError("Index out of bounds")
        }
        
        let entry = entries[index]
        return entry
    }
    
    func numberOfEntries() -> Int {
        return entries.count
    }
    
    func update() {
        updateEntries()
    }

    // MARK: Private functions
    private func updateEntries() {
        
        let context = PersistentService.context
        
        assert(Entry.description() == "Entry")
        let fetchRequest = NSFetchRequest<Entry>(entityName: Entry.description())
        let currentJournal = JournalLibrarian.librarian.getCurrentJournal()
        let journalPredicate = NSPredicate(format: "journal.id = \(currentJournal.id)")
        fetchRequest.predicate = journalPredicate
        
        do {
            var searchResults = try context.fetch(fetchRequest)
            searchResults.sort(by: { (a1, a2) -> Bool in
                let date1 = a1.date
                let date2 = a2.date
                
                return date1 > date2
            })
            entries = searchResults
        }
        catch {
            print("Error: \(error)")
        }
    }
}

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
            update()
        }
    }
    
    private var entries: [Entry] = []
    
    // MARK: Initialization
    private init(timeFrame: TimeFrame) {
        self.timeFrame = timeFrame
        NotificationCenter.default.addObserver(self, selector: #selector(receivedContextChangedNotification), name: .NSManagedObjectContextDidSave, object: nil)
        update()
    }
    
    // MARK: Public
    func getEntry(forIndex index: Int, containingWords words: [String]? = nil) -> Entry {
        if let words = words {
            var currentIndex = -1
            for entry in entries {
                
                var containsAllWords = true
                for word in words {
                    let lowercaseText = entry.text.lowercased()
                    let lowercaseTitle = entry.title.lowercased()
                    if !lowercaseText.contains(word) && !lowercaseTitle.contains(word) {
                        containsAllWords = false
                        break
                    }
                }
                
                if containsAllWords {
                    currentIndex += 1
                }
                
                if currentIndex == index {
                    return entry
                }
            }
            
            fatalError("Should've found an entry")
        }
        
        let entry = entries[index]
        return entry
    }
    
    func getEntries(forJournal journal: Journal) -> [Entry] {
        let context = PersistentService.context
        
        let fetchRequest = NSFetchRequest<Entry>(entityName: Entry.description())
        let journalPredicate = NSPredicate(format: "journal.id = \(journal.id)")
        fetchRequest.predicate = journalPredicate
        
        do {
            var searchResults = try context.fetch(fetchRequest)
            searchResults.sort(by: { (a1, a2) -> Bool in
                let date1 = a1.date
                let date2 = a2.date
                
                return date1 > date2
            })
            return searchResults
        }
        catch {
            print("Error: \(error)")
            fatalError("Error getting entries")
        }
    }
    
    func getIndex(forEntry entry: Entry) -> Int {
        guard let index = entries.index(of: entry) else {
            fatalError("Expected valid index")
        }
        
        return index
    }
    
    func addEntry(title: String, text: String, date: Date) {
        let context = PersistentService.context
        let currentJournal = JournalLibrarian.librarian.getCurrentJournal()
        let newEntry = Entry(context: context)
        
        newEntry.date = date
        newEntry.journal = currentJournal
        newEntry.text = text
        newEntry.title = title
        
        PersistentService.saveContext()
    }
    
    func editEntry(index: Int, title: String? = nil, text: String? = nil, date: Date? = nil, journal: Journal? = nil) {
        let entry = entries[index]
        
        if let title = title {
            entry.title = title
        }
        if let text = text {
            entry.text = text
        }
        if let date = date {
            entry.date = date
        }
        if let journal = journal {
            entry.journal = journal
        }
        
        PersistentService.saveContext()
    }
    
    func deleteEntry(atIndex index: Int) {
        guard index < entries.count else {
            fatalError("Out of bounds")
        }
        
        let entry = entries[index]
        let context = PersistentService.context
        context.delete(entry)
        PersistentService.saveContext()
    }
    
    func numberOfEntries(containingWords words: [String]? = nil) -> Int {
        if let words = words {
            let predicateCount = entries.reduce(0, { (result, entry) -> Int in
                var containsAllWords = true
                for word in words {
                    let lowercaseText = entry.text.lowercased()
                    let lowercaseTitle = entry.title.lowercased()
                    if !lowercaseText.contains(word) && !lowercaseTitle.contains(word) {
                        containsAllWords = false
                        break
                    }
                }
                
                return containsAllWords ? result + 1 : result
            })
            
            return predicateCount
        }
        return entries.count
    }
    
    func numberOfEntriesMadeToday() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        var count = 0
        for entry in entries {
            if calendar.isDateInToday(entry.date) {
                count += 1
            } else {
                break
            }
        }
        
        return count
    }
    
    func update() {
        
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
    
    // MARK: Private functions
    @objc
    private func receivedContextChangedNotification() {
        update()
    }
}

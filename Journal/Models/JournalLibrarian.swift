//
//  JournalLibrarian.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation
import CoreData

class JournalLibrarian {
    
    // MARK: Properties
    static let userDefaultCurrentJournalKeyName = "journal"
    static let librarian = JournalLibrarian()
    
    private var allJournals: [Journal] = []
    
    // MARK: Initialization
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(receivedContextChangedNotification), name: .NSManagedObjectContextDidSave, object: nil)
        update()
    }
    
    // MARK: Public Functions
    
    func getCurrentJournal() -> Journal {
        
        if UserDefaults.standard.value(forKey: JournalLibrarian.userDefaultCurrentJournalKeyName) == nil {
            UserDefaults.standard.set(0, forKey: JournalLibrarian.userDefaultCurrentJournalKeyName)
        }
        
        guard let id = UserDefaults.standard.value(forKey: JournalLibrarian.userDefaultCurrentJournalKeyName) as? Int16 else {
            fatalError("Could not get id")
        }
        
        let queriedJournal = getJournal(withID: id)
        
        if let journal = queriedJournal {
            return journal
        } else {
            let defaultJournal = getJournal(withID: 0)
            guard let journal = defaultJournal else {
                fatalError("Default journal was nil")
            }
            
            setCurrentJournal(journal: journal)
            
            return journal
        }
    }
    
    func setCurrentJournal(journal: Journal) {
        UserDefaults.standard.set(journal.id, forKey: JournalLibrarian.userDefaultCurrentJournalKeyName)
        
        // Let everyone know, we changed the current journal
        NotificationCenter.default.post(Notification(name: .journalChanged))
    }
    
    func deleteJournal(atIndex index: Int) {
        guard index < allJournals.count else {
            fatalError("Out of bounds")
        }
        
        let journal = allJournals[index]
        let context = PersistentService.context
        if journal.id != 0 {
            context.delete(journal)
        } else {
            // Instead of deleting the default journal, we delete all of its entries
            let entriesFetchRequest = NSFetchRequest<Entry>(entityName: Entry.description())
            let defaultJournalPredicate = NSPredicate(format: "journal.id = 0")
            entriesFetchRequest.predicate = defaultJournalPredicate
            do {
                let searchResults = try context.fetch(entriesFetchRequest)
                for entry in searchResults {
                    context.delete(entry)
                }
            } catch {
                print(error)
                fatalError("Could not get entries")
            }
        }
        
        PersistentService.saveContext()
    }
    
    func numberOfJournals() -> Int {
        return allJournals.count
    }
    
    func getJournal(forIndex index: Int) -> Journal {
        guard index < allJournals.count else {
            fatalError("Out of bounds for allJournals")
        }
        
        return allJournals[index]
    }
    
    func getJournals(withName name: String) -> [Journal] {
        let context = PersistentService.context
        let fetchRequest = NSFetchRequest<Journal>(entityName: Journal.description())
        let namePred = NSPredicate(format: "name = \"\(name)\"")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = namePred
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            return searchResults
        } catch  {
            print(error)
            fatalError("Error occured in fetching journals with given name")
        }
    }
    
    func addJournal(name: String) -> Journal {
        let context = PersistentService.context
        let newJournal = Journal(context: context)
        newJournal.name = name
        
        // Find the smallest id not taken by the other journals
        let ids = allJournals.map { (journal) -> Int16 in
            journal.id
        }.sorted()
        
        var smallestAvailableID: Int16 = 0
        for id in ids {
            if smallestAvailableID != id {
                break
            }
            smallestAvailableID += 1
        }
        
        newJournal.id = smallestAvailableID
        
        PersistentService.saveContext()
        
        return newJournal
    }
    
    func update() {
        let context = PersistentService.context
        
        let fetchRequest = NSFetchRequest<Journal>(entityName: Journal.description())
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            
            allJournals = searchResults
        } catch {
            print("Error: \(error)")
        }
    }
    
    /// BE CAREFUL WHEN USING THIS FUNCTION. IT PERMENANTLY DELETES EVERYTHING!!
    func WIPE_EVERYTHING() {
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
        }
    }
    
    // MARK: Private Functions
    /// This function should always return a journal no matter what, if the id is 0
    private func getJournal(withID id: Int16) -> Journal? {
        let context = PersistentService.context
        
        let fetchRequest = NSFetchRequest<Journal>(entityName: Journal.description())
        
        let IDPredicate = NSPredicate(format: "id = \(id)")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = IDPredicate
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            
            assert(searchResults.count <= 1)
            
            if id == 0 && searchResults.isEmpty {
                // Make new journal. There should always be a journal with ID 0
                let newJournal = Journal(context: context)
                newJournal.id = 0
                newJournal.name = "Journal"
                PersistentService.saveContext()
                return newJournal
            }
            guard let journal = searchResults.first else {
                return nil
            }
            
            return journal
        } catch {
            print("Error: \(error)")
        }
        fatalError("Could not get journal with id: \(id)")
    }
    
    @objc
    private func receivedContextChangedNotification() {
        update()
    }
}

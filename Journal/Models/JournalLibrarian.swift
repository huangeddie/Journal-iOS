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
        
        return queriedJournal
    }
    
    func setCurrentJournal(journal: Journal) {
        UserDefaults.standard.set(journal.id, forKey: JournalLibrarian.userDefaultCurrentJournalKeyName)
        
        // Let everyone know, we changed the current journal
        NotificationCenter.default.post(Notification(name: .journalChanged))
    }
    
    func editJournal(atIndex index: Int, name: String) {
        let journal = allJournals[index]
        journal.name = name
        
        PersistentService.saveContext()
    }
    
    func deleteJournal(atIndex index: Int) {
        guard index < allJournals.count else {
            fatalError("Out of bounds")
        }
        
        let journal = allJournals[index]
        
        // Set current journal to something not this
        for j in allJournals {
            if j != journal {
                setCurrentJournal(journal: j)
                break
            }
        }
        
        let context = PersistentService.context
        context.delete(journal)
        
        PersistentService.saveContext()
    }
    
    func numberOfJournals() -> Int {
        return allJournals.count
    }
    
    func getJournal(forIndex index: Int) -> Journal {
        return allJournals[index]
    }
    
    func getJournals(withName name: String) -> [Journal] {
        return allJournals.filter { (journal) -> Bool in
            journal.name == name
        }
    }
    
    func getAllJournals() -> [Journal] {
        return allJournals
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
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [idSort]
        
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
    /// This function should always return a journal no matter what. If no journal is originally found, it creates a journal and sets its id to the given id
    private func getJournal(withID id: Int16) -> Journal {
        let context = PersistentService.context
        
        let fetchRequest = NSFetchRequest<Journal>(entityName: Journal.description())
        
        let IDPredicate = NSPredicate(format: "id = \(id)")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = IDPredicate
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            
            assert(searchResults.count <= 1)
            
            if searchResults.isEmpty {
                // Make new journal.
                let newJournal = Journal(context: context)
                newJournal.id = id
                newJournal.name = "Journal"
                PersistentService.saveContext()
                return newJournal
            }
            guard let journal = searchResults.first else {
                fatalError("Could not get journal")
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

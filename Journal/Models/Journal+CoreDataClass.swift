//
//  Journal+CoreDataClass.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Journal)
public class Journal: NSManagedObject {
    static let userDefaultKeyName = "journal"
    
    static func getCurrentJournal() -> Journal {
        let context = PersistentService.context
        
        let fetchRequest = NSFetchRequest<Journal>(entityName: Journal.description())
        guard let id = UserDefaults.standard.value(forKey: userDefaultKeyName) as? Int16 else {
            fatalError("Could not get current journal id")
        }
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
                fatalError("Could not find journal with id: \(id)")
            }
            
            return journal
        } catch {
            print("Error: \(error)")
        }
        fatalError("Could not get journal with id: \(id)")
    }
}

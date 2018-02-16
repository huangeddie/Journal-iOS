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
    static var timeFrame: TimeFrame = .week
    
    // MARK: Public
    static func getAllEntries(forJournal j: Journal? = nil) -> [Entry] {
        let context = PersistentService.context
        
        let journal: Journal!
        if let j = j {
            journal = j
        } else {
            journal = JournalLibrarian.getCurrentJournal()
        }
        
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
    
    static func getEntry(forIndexPath indexPath: IndexPath, containingWords words: [String]? = nil) -> Entry {
        let entries = getEntries(forSection: indexPath.section, containingWords: words)
        return entries[indexPath.row]
    }
    
    static func getEntries(forSection section: Int, containingWords words: [String]? = nil) -> [Entry] {
        let context = PersistentService.context
        
        let journal = JournalLibrarian.getCurrentJournal()
        
        let (startDate, endDate) = computeStartAndEndDate(forSection: section)
        
        let fetchRequest = NSFetchRequest<Entry>(entityName: Entry.description())
        let predicate = NSPredicate(format: "journal.id = \(journal.id) AND date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
        fetchRequest.predicate = predicate
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            let entries = try context.fetch(fetchRequest)
            return entries
        }
        catch {
            print("Error: \(error)")
            fatalError("Error getting entries")
        }
    }
    
    static func getNumberOfSections() -> Int {
        // Get the oldest entry
        let context = PersistentService.context
        
        let journal = JournalLibrarian.getCurrentJournal()
        
        let fetchRequest = NSFetchRequest<Entry>(entityName: Entry.description())
        let predicate = NSPredicate(format: "journal.id = \(journal.id)")
        fetchRequest.predicate = predicate
        
        let dateSort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.fetchLimit = 1
        
        do {
            let entries = try context.fetch(fetchRequest)
            if entries.isEmpty {
                return 1
            }
            
            guard let oldestEntry = entries.first else {
                fatalError()
            }
            
            let oldestDate = oldestEntry.date
            let currentDate = Date()
            
            let calendar = Calendar.current
            let oldestDateComp = calendar.dateComponents(in: .current, from: oldestDate)
            let currentDateComp = calendar.dateComponents(in: .current, from: currentDate)
            
            let timeDifference = currentDate.timeIntervalSince(oldestDate)
            
            let numberOfSecondsInADay: TimeInterval = 60 * 60 * 24
            
            switch timeFrame {
            case .all:
                return 1
            case .week:
                let numberOfDays = timeDifference / numberOfSecondsInADay
                let numberOfWeeks = numberOfDays / 7
                return Int(numberOfWeeks.rounded(.up)) + 1
            case .month:
                let numberOfYears = currentDateComp.year! - oldestDateComp.year!
                let localDiffOfMonths = currentDateComp.month! - oldestDateComp.month!
                return numberOfYears + localDiffOfMonths + 1
            case .quarter:
                return 1
            case .year:
                let numberOfYears = currentDateComp.year! - oldestDateComp.year!
                return numberOfYears + 1
            }
        }
        catch {
            print("Error: \(error)")
            fatalError("Error getting entries")
        }
    }
    
    static func addEntry(title: String, text: String, date: Date? = nil) -> Entry {
        let context = PersistentService.context
        let currentJournal = JournalLibrarian.getCurrentJournal()
        let newEntry = Entry(context: context)
        
        if let date = date {
            newEntry.date = date
        } else {
            newEntry.date = Date()
        }
        newEntry.journal = currentJournal
        newEntry.text = text
        newEntry.title = title
        
        PersistentService.saveContext()
        
        return newEntry
    }
    
    static func editEntry(entry: Entry, title: String? = nil, text: String? = nil, date: Date? = nil, journal: Journal? = nil) {
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
    
    static func editEntry(atIndexPath indexPath: IndexPath, title: String? = nil, text: String? = nil, date: Date? = nil, journal: Journal? = nil) {
        
        let entry = getEntry(forIndexPath: indexPath)
        editEntry(entry: entry, title: title, text: text, date: date, journal: journal)
    }
    
    static func deleteEntry(_ entry: Entry) {
        let context = PersistentService.context
        context.delete(entry)
        PersistentService.saveContext()
        
        NotificationCenter.default.post(Notification(name: .entryDeleted))
    }
    
    static func deleteEntry(atIndexPath indexPath: IndexPath) {
        let context = PersistentService.context
        let entry = getEntry(forIndexPath: indexPath)
        context.delete(entry)
        PersistentService.saveContext()
    }
    
    static func computeStartAndEndDate(forSection section: Int) -> (Date, Date) {
        let currentDate = Date()
        let calendar = Calendar.current
        
        switch timeFrame {
        case .all:
            return (Date.distantPast, Date())
        case .week:
            let numberOfSecondsInADay = 60 * 60 * 24
            let numberOfSecondsInAWeek = numberOfSecondsInADay * 7
            let offSetDate = Date().addingTimeInterval(TimeInterval(-numberOfSecondsInAWeek * section))
            return (offSetDate.previous(.sunday), offSetDate.next(.sunday))
        case .month:
            let currentMonth = calendar.component(.month, from: currentDate)
        case .year:
            break
        case .quarter:
            break
        }
        
        return (Date(), Date())
    }
    
    // MARK: Private functions
    private static func containsAllWords(entry: Entry, words: [String]) -> Bool {
        var containsAllWords = true
        for word in words {
            let lowercaseText = entry.text.lowercased()
            let lowercaseTitle = entry.title.lowercased()
            if !lowercaseText.contains(word) && !lowercaseTitle.contains(word) {
                containsAllWords = false
                break
            }
        }
        
        return containsAllWords
    }
}

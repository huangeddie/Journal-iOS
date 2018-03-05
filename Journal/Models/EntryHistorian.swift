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
    static var contextWatcher: EntryHistorian!
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(cacheOutDated), name: .NSManagedObjectContextDidSave, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cacheOutDated), name: .journalChanged, object: nil)
    }
    
    // MARK: Properties
    static var calendarComponent: Calendar.Component = .calendar
    
    // Speed things up
    static var cache = [Int:[Entry]]()
    
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
        if let entries = cache[section], words == nil {
            return entries
        }
        
        let context = PersistentService.context
        
        let journal = JournalLibrarian.getCurrentJournal()
        
        let (startDate, endDate) = computeStartAndEndDate(forSection: section)
        
        let fetchRequest = NSFetchRequest<Entry>(entityName: Entry.description())
        
        var predicateString = "journal.id = \(journal.id) AND date >= %@ AND date < %@"
        if let words = words {
            for word in words {
                predicateString += " AND (title CONTAINS[cd] '\(word)' OR text CONTAINS[cd] '\(word)')"
            }
        }
        let predicate = NSPredicate(format: predicateString, startDate as NSDate, endDate as NSDate)
        fetchRequest.predicate = predicate
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            let entries = try context.fetch(fetchRequest)
            
            if words == nil {
                // Set the cache
                cache[section] = entries
            }
            
            return entries
        }
        catch {
            print("Error: \(error)")
            fatalError("Error getting entries")
        }
    }
    
    static func getNumberOfSections() -> Int {
        if calendarComponent == .calendar {
            return 1
        }
        
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
            
            switch calendarComponent {
            case .calendar:
                return 1
            case .weekOfMonth, .weekOfYear:
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
            default:
                return 1
            }
        }
        catch {
            print("Error: \(error)")
            fatalError("Error getting entries")
        }
    }
    
    static func getEntries(since startDate: Date, upTo endDate: Date) -> [Entry] {
        let context = PersistentService.context
        
        let journal = JournalLibrarian.getCurrentJournal()
        
        let fetchRequest = NSFetchRequest<Entry>(entityName: Entry.description())
        
        let predicateString = "journal.id = \(journal.id) AND date >= %@ AND date < %@"
        let predicate = NSPredicate(format: predicateString, startDate as NSDate, endDate as NSDate)
        fetchRequest.predicate = predicate
        
        let dateSort = NSSortDescriptor(key: "date", ascending: true)
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
    
    static func getChartData(for chartCalendarComponent: Calendar.Component) -> ChartData {
        let size: Int
        let dataComponent: Calendar.Component
        switch chartCalendarComponent {
        case .day, .weekday:
            dataComponent = .weekday
            size = 1
        case .weekOfYear, .weekOfMonth:
            dataComponent = .weekday
            size = 7
        case .month:
            dataComponent = .weekOfMonth
            size = 5
        case .quarter:
            dataComponent = .month
            size = 3
        case .year:
            dataComponent = .month
            size = 12
        default:
            dataComponent = .calendar
            size = 1
        }
        
        var data: [Int] = []
        let chartStartDate: Date
        let startComponents: DateComponents
        
        let calendar = Calendar.current
        if dataComponent != .calendar {
            let now = Date()
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
            let startOfTomorrow = calendar.startOfDay(for: tomorrow)
            for i in 0..<size {
                let start = calendar.date(byAdding: dataComponent, value: -(i + 1), to: startOfTomorrow)!
                let end = calendar.date(byAdding: dataComponent, value: -(i), to: startOfTomorrow)!
                let entries = EntryHistorian.getEntries(since: start, upTo: end)
                
                data.append(entries.count)
            }
            data.reverse()
            
            chartStartDate = calendar.date(byAdding: dataComponent, value: -size, to: startOfTomorrow)!
        } else {
            let allEntries = EntryHistorian.getAllEntries()
            data.append(allEntries.count)
            
            chartStartDate = Date.distantPast
        }
        
        startComponents = calendar.dateComponents(in: .current, from: chartStartDate)
        
        let chartData = ChartData(startDate: startComponents, dataCalendarComponent: dataComponent, data: data)
        return chartData
    }
    
    
    
    static func partition(entries: [Entry], into n: Int, startDate: Date, endDate: Date) -> [Int] {
        var ret: [Int] = []
        
        let interval = endDate.timeIntervalSince(startDate) / TimeInterval(n)
        var aDate = startDate
        var bDate = startDate.addingTimeInterval(interval)

        for _ in 1...n {
            let count = entries.reduce(0, { (currentCount, entry) -> Int in
                if aDate <= entry.date && entry.date < bDate{
                    return currentCount + 1
                }
                return currentCount
            })
            ret.append(count)
            
            aDate = bDate
            bDate = bDate.addingTimeInterval(interval)
        }
        
        assert(ret.count == n)
        return ret
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
        let distantPast = Date.distantPast
        return (distantPast, Date())
    }
    
    // MARK: Private functions
    @objc
    private func cacheOutDated() {
        EntryHistorian.cache.removeAll()
    }
}

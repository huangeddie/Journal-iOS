//
//  Downloader.swift
//  Journal
//
//  Created by Edward Huang on 1/10/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

class Downloader {
    class func load(URL: URL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")
                
                guard let data = data else {
                    fatalError("Data is nil")
                }
                
                // Get JSON object
                let JSON: [String: [[String: String]]]
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: [[String: String]]] else {
                        fatalError("Could not parse JSON object")
                    }
                    
                    JSON = json
                } catch {
                    print(error)
                    fatalError("Could not parse JSON object")
                }
                
                // Parse JSON object and create journal and entries from it
                let librarian = JournalLibrarian.librarian
                
                // Wipe everything
                librarian.WIPE_EVERYTHING()
                let context = PersistentService.context
                
                for (journal, contents) in JSON {
                    let currentJournal: Journal
                    
                    // Find existing journals
                    let existingJournals = librarian.getJournals(withName: journal)
                    if existingJournals.isEmpty {
                        // Add a new journal
                        currentJournal = librarian.addJournal(name: journal)
                    } else {
                        guard let j = existingJournals.first else {
                            fatalError("Could not get a journal from fetched journals")
                        }
                        currentJournal = j
                    }
                    
                    librarian.setCurrentJournal(journal: currentJournal)
                    
                    for entry in contents {
                        guard let dateString = entry["date"], let title = entry["title"], let text = entry["text"] else {
                            fatalError("Could not get parameters")
                        }
                        
                        let substrings = dateString.split(separator: " ")
                        let month = substrings[0]
                        let day = substrings[1]
                        let year = substrings[2]
                        
                        var components = DateComponents()
                        components.year = Int("20" + year)
                        components.month = Int(month)
                        components.day = Int(day)
                        
                        guard let date = Calendar(identifier: .gregorian).date(from: components) else {
                            fatalError("Could not get date")
                        }
                        
                        let newEntry = Entry(context: context)
                        newEntry.journal = currentJournal
                        newEntry.date = date
                        newEntry.title = title
                        newEntry.text = text
                    }
                }
                
                PersistentService.saveContext()
            }
            else {
                // Failure
                print("Failure: %@", error?.localizedDescription ?? "");
            }
        })
        task.resume()
    }
}

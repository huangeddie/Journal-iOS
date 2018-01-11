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
                
                
                for (journal, contents) in JSON {
                    
                    let currentJournal: Journal
                    
                    // Find existing journals
                    let existingJournals = JournalLibrarian.librarian.getJournal(withName: journal)
                    if existingJournals.isEmpty {
                        // Add a new journal
                        currentJournal = JournalLibrarian.librarian.addJournal(name: journal)
                    } else {
                        guard let j = existingJournals.first else {
                            fatalError("Could not get a journal from fetched journals")
                        }
                        currentJournal = j
                    }
                    
                    print(journal)
                    for entry in contents {
                        guard let date = entry["date"], let title = entry["title"], let text = entry["text"] else {
                            fatalError("Could not get parameters")
                        }
                        
                        print("Date: \(date)")
                        print("Title: \(title)")
                        print("Text: \(text)")
                    }
                }
                
                
            }
            else {
                // Failure
                print("Failure: %@", error?.localizedDescription);
            }
        })
        task.resume()
    }
}

//
//  Exporter.swift
//  Journal
//
//  Created by Edward Huang on 1/13/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation
import MessageUI

class Exporter {
    static func getExportJournalMailComposerVC(delegate: MFMailComposeViewControllerDelegate) -> MFMailComposeViewController? {
        //Check to see the device can send email.
        if( MFMailComposeViewController.canSendMail() ) {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = delegate
            
            mailComposer.setSubject("Diunalis")
            mailComposer.setMessageBody("Your voice in JSON format:", isHTML: false)
            
            // Create JSON object of current journals
            var json = [String: [[String: Any]]]()
            
            let allJournals = JournalLibrarian.getAllJournals()
            
            for journal in allJournals {
                json[journal.name] = [[String: Any]]()
                
                let entries = EntryHistorian.getAllEntries(forJournal: journal)
                
                for entry in entries {
                    var e = [String: Any]()
                    let df = DateFormatter.RFC3339DateFormatter
                    e["date"] = df.string(from: entry.date)
                    e["title"] = entry.title
                    e["text"] = entry.text
                    json[journal.name]?.append(e)
                }
            }
            
            guard JSONSerialization.isValidJSONObject(json) else {
                fatalError("Invalid JSON object")
            }
            
            let jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            } catch {
                print(error)
                fatalError("Could not serialize json")
            }
            
            
            mailComposer.addAttachmentData(jsonData, mimeType: "text/plain", fileName: "Diurnalis.JSON.txt")
            
            return mailComposer
        }
        return nil
    }
}

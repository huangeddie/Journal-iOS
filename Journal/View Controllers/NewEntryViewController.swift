//
//  NewEntryViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class NewEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Watch for any change to the journal
        NotificationCenter.default.addObserver(self, selector: #selector(receievedJournalChangeNotification), name: .journalChanged, object: nil)
        
        let journal = JournalLibrarian.librarian.getCurrentJournal()
        navigationItem.title = journal.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let navVC = segue.destination as? UINavigationController {
            if let editEntryVC = segue.destination as? EditEntryViewController {
                EntryHistorian.historian.addEntry(title: "", text: "", date: Date())
            }
        }
    }
 
    
    // MARK: Private Functions
    @objc
    private func receievedJournalChangeNotification() {
        let currentJournal = JournalLibrarian.librarian.getCurrentJournal()
        navigationItem.title = currentJournal.name
    }
}

//
//  NewEntryViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit
import MessageUI

class NewEntryViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    let historian = EntryHistorian.historian
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Watch for any change to the journal
        NotificationCenter.default.addObserver(self, selector: #selector(receievedJournalChangeNotification), name: .journalChanged, object: nil)
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup UI
        let journal = JournalLibrarian.librarian.getCurrentJournal()
        navigationItem.title = journal.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
            if let editEntryVC = navVC.childViewControllers.first as? EditEntryViewController {
                EntryHistorian.historian.addEntry(title: "", text: "", date: Date())
                editEntryVC.indexToEdit = 0
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

extension NewEntryViewController: UITableViewDelegate, UITableViewDataSource {
    
    private static let cellIdentifier = "entry_cell"
    
    // MARK: Delegate
    
    // MARK: Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return historian.numberOfEntriesMadeToday()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewEntryViewController.cellIdentifier) else {
            fatalError("Could not get cell")
        }
        
        let entry = historian.getEntry(forIndex: indexPath.row)
        
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = df.string(from: entry.date)
        
        return cell
    }
}

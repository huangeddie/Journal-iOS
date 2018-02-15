//
//  EntryCollectionViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class EntryCollectionViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var entryHistorian: EntryHistorian = EntryHistorian.historian
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Search Bar
        searchBar.delegate = self
        // Add a "Cancel" button for the keyboard
        searchBar.addCancelButtonAccessory()
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        // Watch for any changes to the entries
        NotificationCenter.default.addObserver(self, selector: #selector(receivedJournalChangeNotification), name: .NSManagedObjectContextDidSave, object: nil)
        
        // Watch for any changes to the journals
        NotificationCenter.default.addObserver(self, selector: #selector(receivedJournalChangeNotification), name: Notification.Name.journalChanged, object: nil)
        entryHistorian.update()
        
        // Set title to current journal
        let currentJournal = JournalLibrarian.librarian.getCurrentJournal()
        navigationItem.title = currentJournal.name
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
        let viewSpecificEntrySegueIdentifier = "view_specific_entry"
        let newEntrySegueIdentifier = "new_entry"
        
        switch segue.identifier ?? "" {
        case viewSpecificEntrySegueIdentifier:
            guard let row = tableView.indexPathsForSelectedRows?.first?.row else {
                fatalError("An entry was not selected")
            }
            
            guard let viewEntryVC = segue.destination as? ViewEntryViewController else {
                fatalError("First child is not a ViewEntryViewController")
            }
            
            // Collection row is not necessarily same as entry index due to keyword search
            let words = searchBar.getLowerCaseWords()
            let entry = entryHistorian.getEntry(forIndex: row, containingWords: words)
            
            let index = entryHistorian.getIndex(forEntry: entry)
            
            viewEntryVC.index = index
        case newEntrySegueIdentifier:
            if let navVC = segue.destination as? UINavigationController {
                if let editEntryVC = navVC.childViewControllers.first as? EditEntryViewController {
                    EntryHistorian.historian.addEntry(title: "", text: "", date: Date())
                    editEntryVC.indexToEdit = 0
                }
            }
        default:
            // Do nothing
            break
        }
    }
 
    
    // MARK: Private functions
    
    @objc
    private func resignKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    @objc
    private func receivedJournalChangeNotification() {
        entryHistorian.update()
        
        // Update title
        let currentJournal = JournalLibrarian.librarian.getCurrentJournal()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.navigationItem.title = currentJournal.name
        }
    }
    
    @objc
    private func receivedContextChangeNotification() {
        entryHistorian.update()
        tableView.reloadData()
    }
}

extension EntryCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension EntryCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    private static let cellIdentifier = "entry_cell"
    
    // MARK: Delegate
    
    
    
    // MARK: Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let words = searchBar.getLowerCaseWords()
        
        return entryHistorian.numberOfEntries(containingWords: words)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryCollectionViewController.cellIdentifier) as? EntryTableViewCell else {
            fatalError("Could not get proper cell")
        }
        
        let words = searchBar.getLowerCaseWords()
        
        let entry = entryHistorian.getEntry(forIndex: indexPath.row, containingWords: words)
        
        let date = entry.date
        let df = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            df.dateStyle = .none
            df.timeStyle = .short
        } else {
            df.dateStyle = .short
            df.timeStyle = .none
        }

        cell.dateLabel.text = df.string(from: entry.date)
        cell.titleLabel.text = entry.title
        cell.passageLabel.text = entry.text
        
        return cell
    }
    
}

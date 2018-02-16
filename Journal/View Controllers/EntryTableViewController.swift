//
//  EntryCollectionViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class EntryTableViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
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
        
        // Set title to current journal
        let currentJournal = JournalLibrarian.getCurrentJournal()
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
            guard let indexPath = tableView.indexPathsForSelectedRows?.first else {
                fatalError("An entry was not selected")
            }
            
            guard let viewEntryVC = segue.destination as? ViewEntryViewController else {
                fatalError("First child is not a ViewEntryViewController")
            }
            
            // Collection row is not necessarily same as entry index due to keyword search
            let words = searchBar.getLowerCaseWords()
            let entry = EntryHistorian.getEntry(forIndexPath: indexPath, containingWords: words)
            viewEntryVC.entry = entry
        case newEntrySegueIdentifier:
            if let navVC = segue.destination as? UINavigationController {
                if let editEntryVC = navVC.childViewControllers.first as? EditEntryViewController {
                    let entry = EntryHistorian.addEntry(title: "", text: "", date: Date())
                    editEntryVC.entryToEdit = entry
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
        // Update title
        let currentJournal = JournalLibrarian.getCurrentJournal()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.navigationItem.title = currentJournal.name
        }
    }
    
    @objc
    private func receivedContextChangeNotification() {
        tableView.reloadData()
    }
}

extension EntryTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension EntryTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    private static let cellIdentifier = "entry_cell"
    
    // MARK: Delegate
    
    // MARK: Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return EntryHistorian.getNumberOfSections()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let words = searchBar.getLowerCaseWords()
        
        let entries = EntryHistorian.getEntries(forSection: section, containingWords: words)
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewController.cellIdentifier) as? EntryTableViewCell else {
            fatalError("Could not get proper cell")
        }
        
        let words = searchBar.getLowerCaseWords()
        
        let entry = EntryHistorian.getEntry(forIndexPath: indexPath, containingWords: words)
        
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
        cell.entry = entry
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let (startDate, endDate) = EntryHistorian.computeStartAndEndDate(forSection: section)
        
        let df = DateFormatter()
        df.dateStyle = .medium
        
        return "\(df.string(from: startDate)) - \(df.string(from: endDate))"
        
    }
    
}

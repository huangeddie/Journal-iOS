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
    @IBOutlet weak var timeFrameSegmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var entryHistorian: EntryHistorian = EntryHistorian.historian
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Search Bar
        searchBar.delegate = self
        // Add a "Cancel" button for the keyboard
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(resignKeyboard))
        
        
        toolBar.setItems([flexibleSpace, cancelItem], animated: true)
        
        searchBar.inputAccessoryView = toolBar
        
        // TableView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // SegmentControl
        timeFrameSegmentControl.addTarget(self, action: #selector(segmentControlValueDidChange), for: .valueChanged)
        let selectedIndex = timeFrameSegmentControl.selectedSegmentIndex
        guard let timeFrame = TimeFrame(rawValue: selectedIndex) else {
            fatalError("Could not get time frame")
        }
        entryHistorian.timeFrame = timeFrame
        
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
        
        guard let row = collectionView.indexPathsForSelectedItems?.first?.row else {
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
            self.collectionView.reloadData()
            self.navigationItem.title = currentJournal.name
        }
    }
    
    @objc
    private func receivedContextChangeNotification() {
        entryHistorian.update()
        collectionView.reloadData()
    }
    
    // MARK: Segment Control
    @objc
    private func segmentControlValueDidChange() {
        let rawValue = timeFrameSegmentControl.selectedSegmentIndex
        guard let newTimeFrame = TimeFrame(rawValue: rawValue) else {
            fatalError("Could not get time frame")
        }
        
        entryHistorian.timeFrame = newTimeFrame
        
        collectionView.reloadData()
    }
}

extension EntryCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension EntryCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private static let cellIdentifier = "entry_cell"
    
    // MARK: Delegate
    
    
    
    // MARK: Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let words = searchBar.getLowerCaseWords()
        
        return entryHistorian.numberOfEntries(containingWords: words)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EntryCollectionViewController.cellIdentifier, for: indexPath) as? EntryCollectionViewCell else {
            fatalError("Could not get proper cell")
        }
        
        let words = searchBar.getLowerCaseWords()
        
        let entry = entryHistorian.getEntry(forIndex: indexPath.row, containingWords: words)
        
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        
        cell.dateLabel.text = df.string(from: entry.date)
        cell.titleLabel.text = entry.title
        cell.textLabel.text = entry.text
        
        return cell
    }
    
}

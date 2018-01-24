//
//  JournalCollectionViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit
import MessageUI

class JournalCollectionViewController: UIViewController {

    // MARK: Properties
    let journalLibrarian = JournalLibrarian.librarian
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the title
        let currentJournal = JournalLibrarian.librarian.getCurrentJournal()
        navigationItem.title = currentJournal.name
        
        // Watch for any changes to the selection of journals
        NotificationCenter.default.addObserver(self, selector: #selector(receivedJournalChangeNotification), name: .journalChanged, object: nil)
        // Watch for any change to the addition of journals
        NotificationCenter.default.addObserver(self, selector: #selector(receivedContextChangedNotification), name: .NSManagedObjectContextDidSave, object: nil)
        
        journalLibrarian.update()
        
        // Setup the table view
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: IBActions
    
    @IBAction func actionPressed(_ sender: Any) {
        
        let mailComposerVC = Exporter.getExportJournalMailComposerVC(delegate: self)
        if let mailComposerVC = mailComposerVC {
            present(mailComposerVC, animated: true, completion: nil)
        }   
    }
    @IBAction func addJournalPressed(_ sender: Any) {
        let alertVC = UIAlertController(title: "New Journal", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
            guard let textField = alertVC.textFields?.first else {
                fatalError("Could not get text field")
            }
            guard let text = textField.text else {
                fatalError("Could not get text")
            }
            
            _ = self.journalLibrarian.addJournal(name: text)
            
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: Private Functions
    @objc
    private func receivedJournalChangeNotification() {
        let currentJournal = JournalLibrarian.librarian.getCurrentJournal()
        navigationItem.title = currentJournal.name
    }
    
    @objc
    private func receivedContextChangedNotification() {
        // A journal might have been added
        journalLibrarian.update()
        collectionView.reloadData()
    }
}

extension JournalCollectionViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension JournalCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    static let cellIdentifier = "journal_cell"
    
    // MARK: Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let selectedJournal = journalLibrarian.getJournal(forIndex: row)
        
        journalLibrarian.setCurrentJournal(journal: selectedJournal)
    }
    
    // MARK: Data Source
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let journal = journalLibrarian.getJournal(forIndex: row)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JournalCollectionViewController.cellIdentifier, for: indexPath) as? JournalCollectionViewCell else {
            fatalError("Unknown collection view cell")
        }
        
        cell.title?.text = journal.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return journalLibrarian.numberOfJournals()
    }
}

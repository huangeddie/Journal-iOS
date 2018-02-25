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
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var journalIndexToEdit = 0
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the title
        let currentJournal = JournalLibrarian.getCurrentJournal()
        navigationItem.title = currentJournal.name
        
        // Watch for any changes to the selection of journals
        NotificationCenter.default.addObserver(self, selector: #selector(receivedJournalChangeNotification), name: .journalChanged, object: nil)
        // Watch for any change to the addition of journals
        NotificationCenter.default.addObserver(self, selector: #selector(receivedContextChangedNotification), name: .NSManagedObjectContextDidSave, object: nil)
        
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
            
            _ = JournalLibrarian.addJournal(name: text)
            
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func downloadPressed(_ sender: Any) {
        let urlLoader = UIAlertController(title: "Enter the URL of JSON file", message: "If you don't understand this. Don't worry. You can ignore this feature completely!", preferredStyle: .alert)
        urlLoader.addTextField { (textfield) in
            textfield.returnKeyType = .done
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            urlLoader.dismiss(animated: true, completion: nil)
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            if let text = urlLoader.textFields?.first?.text {
                if let url = URL(string: text) {
                    Downloader.load(URL: url)
                }
            }
            
            urlLoader.dismiss(animated: true, completion: nil)
        }
        
        urlLoader.addAction(cancelAction)
        urlLoader.addAction(submitAction)
        
        present(urlLoader, animated: true, completion: nil)
    }
    
    // MARK: Private Functions
    @objc
    func journalLongPressed(_ sender: JournalLongPressGestureRecognizer) {
        let editJournalVCIdentifier = "edit_journal"
        
        guard let editVC = UIStoryboard(name: UIStoryboard.main, bundle: nil).instantiateViewController(withIdentifier: editJournalVCIdentifier) as? EditJournalViewController else {
            fatalError("Could not get edit journal vc")
        }
        
        let navVC = UINavigationController()
        navVC.pushViewController(editVC, animated: false)
        
        let index = sender.journalIndex
        editVC.indexToEdit = index
        
        present(navVC, animated: true, completion: nil)
    }
    
    @objc
    private func receivedJournalChangeNotification() {
        let currentJournal = JournalLibrarian.getCurrentJournal()
        navigationItem.title = currentJournal.name
    }
    
    @objc
    private func receivedContextChangedNotification() {
        // A journal might have been added
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        
        let selectedJournal = JournalLibrarian.getJournal(forIndex: row)
        
        JournalLibrarian.setCurrentJournal(journal: selectedJournal)
    }
    
    // MARK: Data Source
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let journal = JournalLibrarian.getJournal(forIndex: row)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JournalCollectionViewController.cellIdentifier, for: indexPath) as? JournalCollectionViewCell else {
            fatalError("Unknown collection view cell")
        }
        
        cell.journal = journal
        
        cell.title?.text = journal.name
        
        let longPress = JournalLongPressGestureRecognizer()
        longPress.journalIndex = row
        longPress.addTarget(self, action: #selector(journalLongPressed))
        cell.addGestureRecognizer(longPress)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return JournalLibrarian.numberOfJournals()
    }
}


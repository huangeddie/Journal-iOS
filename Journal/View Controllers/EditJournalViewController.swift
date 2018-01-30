//
//  EditJournalViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/29/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class EditJournalViewController: UIViewController {

    @IBOutlet weak var journalTitle: UITextField!
    let librarian = JournalLibrarian.librarian
    var indexToEdit: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        journalTitle.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let journal = librarian.getJournal(forIndex: indexToEdit)
        journalTitle.text = journal.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    @IBAction func backPressed(_ sender: Any) {
        
        if let newTitle = journalTitle.text {
            librarian.editJournal(atIndex: indexToEdit, name: newTitle)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func trashPressed(_ sender: Any) {
        // Prompt alert to confirm
        let confirmAlert = UIAlertController(title: "Are you sure you want to delete this journal?", message: "This action cannot be undone", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            confirmAlert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.librarian.deleteJournal(atIndex: self.indexToEdit)
            confirmAlert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        
        confirmAlert.addAction(cancelAction)
        confirmAlert.addAction(deleteAction)
        
        present(confirmAlert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditJournalViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

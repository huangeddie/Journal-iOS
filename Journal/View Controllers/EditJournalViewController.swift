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
        
        dismiss(animated: true, completion: nil)
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

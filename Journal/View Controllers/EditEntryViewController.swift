//
//  EditEntryViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/7/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit
import MessageUI

class EditEntryViewController: UIViewController {
    
    // MARK: Properties
    var editingANewEntry = true
    var entryToEdit: Entry!
    var newJournal: Journal!
    
    private var defaultScrollAndContentInsets: UIEdgeInsets!
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a "Done" button for the keyboard
        textView.addDoneButtonAccessory()
        
        // Text View Delegation
        titleTextView.delegate = self
        
        // Pay attention to when keyboard is shown and hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Setup the new journal
        newJournal = entryToEdit.journal
        
        // Setup the new date
        datePicker.date = entryToEdit.date
        // We don't want the user to modify the date. If they really want, they can do that later by editing it
        if editingANewEntry {
            datePicker.isUserInteractionEnabled = false
            // Disable the delete button
            deleteButton.isEnabled = false
        } else {
            // Disable the delete button
            deleteButton.isEnabled = true
        }
        
        // Setup the new title
        titleTextView.text = entryToEdit.title
        
        // Setup the new text
        textView.text = entryToEdit.text
        
        // Content Insets
        defaultScrollAndContentInsets = UIEdgeInsetsMake(0, 0, toolbar.frame.height, 0)
        textView.contentInset = defaultScrollAndContentInsets
        textView.scrollIndicatorInsets = defaultScrollAndContentInsets
        
        updateUI()
        
        // Assign title as first responder
        if editingANewEntry {
            titleTextView.becomeFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 
    
    // MARK: IBActions
    
    /// If this VC was editing a new entry, it removes that new entry from the data base. Otherwise it is editing an old entry, in which case it simply dismisses the VC, not committing any changes made to the text view to the entry's text
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func cancelPressed(_ sender: Any) {
        
        if editingANewEntry {
            // Remove that entry
            EntryHistorian.deleteEntry(entryToEdit)
        }
        
        // Dismiss
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        // Dismiss
        titleTextView.resignFirstResponder()
        textView.resignFirstResponder()
        
        // Commit changes made from text view to entry's text
        
        let newDate = datePicker.date
        
        let newText = textView.text
        
        let newTitle = titleTextView.text
        
        EntryHistorian.editEntry(entry: entryToEdit, title: newTitle, text: newText, date: newDate, journal: newJournal)
        
        dismiss(animated: true)
    }
    
    @IBAction func deleteEntry(_ sender: Any) {
        deleteEntry()
    }
    
    
    @IBAction func unwindToEditEntry(_ sender: UIStoryboardSegue) {
        if let changeJournalTVC = sender.source as? ChangeJournalTableViewController {
            newJournal = changeJournalTVC.selectedJournal
            updateUI()
        }
    }
    
    // MARK: Private Functions
    
    @objc
    private func keyboardDidShow(aNotification: NSNotification) {
        guard let info = aNotification.userInfo as NSDictionary? else {
            fatalError("Could not get NSDictionary")
        }
        
        guard let kbRect = info.object(forKey: UIKeyboardFrameEndUserInfoKey) as? CGRect else {
            fatalError("Could not get keyboard rect")
        }
        let kbSize = kbRect.size
        
        let textViewBottomOffset: CGFloat = 0
        
        let contentInsets = UIEdgeInsetsMake(defaultScrollAndContentInsets.top, defaultScrollAndContentInsets.left, kbSize.height - textViewBottomOffset, defaultScrollAndContentInsets.right)
        textView.contentInset = contentInsets
        
        let scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kbSize.height - textViewBottomOffset, 0)
        textView.scrollIndicatorInsets = scrollIndicatorInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
    }
    
    @objc
    private func keyboardWillHide() {
        let zeroContentInsets = UIEdgeInsets.zero
        textView.contentInset = defaultScrollAndContentInsets
        textView.scrollIndicatorInsets = defaultScrollAndContentInsets
    }
    
    private func deleteEntry() {
        // Present an alert VC to confirm.
        // If confirmed, delete entry and then dismiss
        let confirmAlertVC = UIAlertController(title: "Are you sure you want to delete this entry?", message: "This action cannot be undone", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            confirmAlertVC.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            // Delete the entry
            EntryHistorian.deleteEntry(self.entryToEdit)
            self.dismiss(animated: true)
        }
        
        confirmAlertVC.addAction(cancelAction)
        confirmAlertVC.addAction(deleteAction)
        
        present(confirmAlertVC, animated: true, completion: nil)
    }
    
    private func updateUI() {
        navigationItem.title = newJournal.name
    }
    
    @objc
    private func resignKeyboard() {
        let result = textView.resignFirstResponder()
        assert(result)
        
        guard let text = textView.text else {
            fatalError("Could not get text from text field")
        }
        
        EntryHistorian.editEntry(entry: entryToEdit, text: text)
    }
}

extension EditEntryViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            if textView == titleTextView {
                self.textView.becomeFirstResponder()
            }
            return false
        }
        return true
    }
}

extension EditEntryViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        // Dismiss the edit entry VC itself
        dismiss(animated: true, completion: nil)
    }
}

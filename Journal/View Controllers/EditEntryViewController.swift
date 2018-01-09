//
//  EditEntryViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/7/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class EditEntryViewController: UIViewController {
    
    // MARK: Properties
    var shouldPromptChangeTitle = true
    var entry: Entry!
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a "Done" button for the keyboard
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(resignKeyboard))
        
        
        toolBar.setItems([flexibleSpace, doneItem], animated: true)
        
        textView.inputAccessoryView = toolBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Setup the entry
        if entry == nil {
            entry = Entry(context: PersistentService.context)
            let currentJournal = JournalLibrarian.getCurrentJournal()
            entry.journal = currentJournal
            
            entry.date = Date()
            entry.text = ""
            guard let title = navigationItem.title else {
                fatalError("Could not get navigation title")
            }
            entry.title = title
        }
        
        // Prompt the title change
        if shouldPromptChangeTitle {
            alertChangeTitle()
        }
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
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        // Reset the context
        let context = PersistentService.context
        
        assert(context.hasChanges)
        
        context.reset()
        
        assert(!context.hasChanges)
        
        // Dismiss
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        // Save the context
        PersistentService.saveContext()
        
        // Dismiss
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeTitlePressed(_ sender: Any) {
        
        alertChangeTitle()
        
    }
    
    // MARK: Private Functions
    
    @objc
    private func resignKeyboard() {
        let result = textView.resignFirstResponder()
        assert(result)
        
        guard let text = textView.text else {
            fatalError("Could not get text from text field")
        }
        entry.text = text
    }
    
    /// Show an alert to change the title
    private func alertChangeTitle() {
        let alertChangeTitle = UIAlertController(title: "Set Title", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // something?
        }
        
        let doneAction = UIAlertAction(title: "Set", style: .default) { (action) in
            // something?
            if let newTitle = alertChangeTitle.textFields?.first?.text {
                self.navigationItem.title = newTitle
                self.entry.title = newTitle
            }
        }
        
        alertChangeTitle.addAction(cancelAction)
        alertChangeTitle.addAction(doneAction)
        
        alertChangeTitle.addTextField { (textField) in
            // Auto capitalize words because it is a title
            textField.autocapitalizationType = UITextAutocapitalizationType.words
        }
        
        present(alertChangeTitle, animated: true, completion: nil)
    }
}

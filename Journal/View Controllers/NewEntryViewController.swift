//
//  NewEntryViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/7/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class NewEntryViewController: UIViewController {
    
    // MARK: Properties
    
    var entry: Entry!
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(resignKeyboard))
        
        
        toolBar.setItems([flexibleSpace, doneItem], animated: true)
        
        textField.inputAccessoryView = toolBar
        
        
        // Setup the entry
        entry = Entry(context: PersistentService.context)
        entry.date = Date()
        entry.text = ""
        guard let title = navigationItem.title else {
            fatalError("Could not get navigation title")
        }
        entry.title = title

        // Do any additional setup after loading the view.
        alertChangeTitle()
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
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        // Save the context
        PersistentService.saveContext()
        
        // Dismiss
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeTitlePressed(_ sender: Any) {
        
        alertChangeTitle()
        
    }
    
    // MARK: Private Functions
    
    @objc
    private func resignKeyboard() {
        let result = textField.resignFirstResponder()
        assert(result)
        
        guard let text = textField.text else {
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

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
        
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
        
        toolBar.setItems([cancelItem], animated: true)
        
        textField.inputAccessoryView = toolBar
        

        
        // Setup the entry
        entry = Entry(context: PersistentService.context)
        entry.date = Date()
        entry.text = ""
        entry.title = ""

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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        // Save the context
        PersistentService.saveContext()
        
        // Dismiss
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeTitlePressed(_ sender: Any) {
        
        alertChangeTitle()
        
    }
    
    // MARK: Private Functions
    
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
            // something?
        }
        
        present(alertChangeTitle, animated: true, completion: nil)
    }
}

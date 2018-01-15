//
//  ViewEntryViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class ViewEntryViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var entryHistorian: EntryHistorian = EntryHistorian.historian
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add some margins to the textview
        textView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let entry = entryHistorian.getEntry(forIndex: index)
        
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        
        dateLabel.text = df.string(from: entry.date)
        
        navigationItem.title = entry.journal.name
        
        titleTextView.text = entry.title
        
        let text = entry.text
        textView.text = text
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
        
        guard let navVC = segue.destination as? UINavigationController else {
            fatalError("Destination is not a UINavigationController")
        }
        
        guard let editEntryVC = navVC.childViewControllers.first as? EditEntryViewController else {
            fatalError("First child is not a ViewEntryViewController")
        }
        
        editEntryVC.editingANewEntry = false
        editEntryVC.indexToEdit = index
    }
}

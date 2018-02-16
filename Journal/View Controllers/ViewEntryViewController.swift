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
    
    var entryToView: Entry!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Watch for deleted entry
        NotificationCenter.default.addObserver(self, selector: #selector(entryDeleted), name: .entryDeleted, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if entryToView == nil {
            navigationController?.popViewController(animated: true)
            return
        }
        
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        
        dateLabel.text = df.string(from: entryToView.date)
        
        navigationItem.title = entryToView.journal.name
        
        titleTextView.text = entryToView.title
        
        let text = entryToView.text
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
        editEntryVC.entryToEdit = entryToView
        editEntryVC.editingANewEntry = false
    }
    
    // MARK: Private functions
    @objc
    private func entryDeleted() {
        entryToView = nil
        if let navVC = navigationController {
            presentedViewController?.dismiss(animated: true)
            let children = navVC.viewControllers
            navVC.popToViewController(children[1], animated: true)
        }
    }
}

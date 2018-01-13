//
//  DateChangerViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/13/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class DateChangerViewController: UIViewController {
    
    var indexToEdit: Int!
    let historian = EntryHistorian.historian

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the date to the date by the entry
        let entry = historian.getEntry(forIndex: indexToEdit)
        
        datePicker.setDate(entry.date, animated: false)
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let date = datePicker.date
        
        historian.editEntry(index: indexToEdit, date: date)
        
        dismiss(animated: true, completion: nil)
    }
}

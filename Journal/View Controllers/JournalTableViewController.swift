//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class JournalTableViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the title
        let currentJournal = JournalLibrarian.getCurrentJournal()
        navigationItem.title = currentJournal.name
        
        
        // Setup the table view
        tableView.delegate = self
        tableView.dataSource = self
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

}

extension JournalTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    static let cellIdentifier = "journal_cell"
    
    // MARK: Delegate
    
    
    // MARK: Data Source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let journal = JournalLibrarian.getJournal(for: row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: JournalTableViewController.cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = journal.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return JournalLibrarian.numberOfJournals()
        }
        return 0
    }
    
}

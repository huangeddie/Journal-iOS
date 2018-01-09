//
//  EntryTableViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class EntryTableViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var timeFrameSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var entryHistorian: EntryHistorian = EntryHistorian(timeFrame: .week)
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        timeFrameSegmentControl.addTarget(self, action: #selector(segmentControlValueDidChange), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedContextChangeNotification), name: PersistentService.contextChangedNotificationName, object: nil)
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
        
        guard let row = tableView.indexPathForSelectedRow?.row else {
            fatalError("An entry was not selected")
        }
        
        let entry = entryHistorian.getEntry(for: row)
        
    }
 
    
    // MARK: Private functions
    @objc
    private func receivedContextChangeNotification() {
        entryHistorian.update()
        tableView.reloadData()
    }
    
    // MARK: Segment Control
    @objc
    private func segmentControlValueDidChange() {
        let rawValue = timeFrameSegmentControl.selectedSegmentIndex
        guard let newTimeFrame = TimeFrame(rawValue: rawValue) else {
            fatalError("Could not get time frame")
        }
        
        entryHistorian.timeFrame = newTimeFrame
        
        tableView.reloadData()
    }
}

extension EntryTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    private static let cellIdentifier = "entry_cell"
    
    // MARK: Delegate
    
    
    
    // MARK: Data Source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let entry = entryHistorian.getEntry(for: row)
        guard let date = entry.date else {
            fatalError("Could not get date from entry")
        }
        guard let title = entry.title else {
            fatalError("Could not get title from entry")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewController.cellIdentifier, for: indexPath)
        
        // Format cell
        cell.textLabel?.text = title
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yy")
        let dateString = dateFormatter.string(from: date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return entryHistorian.numberOfEntries()
        }
        return 0
    }
    
}

//
//  StatisticsViewController.swift
//  Journal
//
//  Created by Edward Huang on 2/25/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var chart: ChartView!
    @IBOutlet weak var timeFrame: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    
    @IBAction func timeFrameChanged(_ sender: UISegmentedControl) {
        updateChart()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private Functions
    private func updateChart() {
        let tf = TimeFrame(rawValue: timeFrame.selectedSegmentIndex)!
        let numberOfDays = tf.estimatedNumberOfDays
        let numberOfWeeks = tf.estimatedNumberOfWeeks
        let now = Date()
        let offSet = now.addingTimeInterval(-TimeInterval(numberOfDays) * TimeInterval.numberOfSecondsInADay)
        let calendar = Calendar.current
        let date = tf != .all ? calendar.startOfDay(for: offSet) : now
        
        let entries = EntryHistorian.getEntriesPast(date: date)
        let yValues = EntryHistorian.partition(entries: entries, into: tf == .week ? numberOfDays : numberOfWeeks, startDate: date, endDate: now)
        
        chart.configure(yValues: yValues, bottomXLabels: ["", ""], topXLabels: ["Month"])
    }

}

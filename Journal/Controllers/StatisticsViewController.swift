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
        let tf = TimeFrame(rawValue: timeFrame.selectedSegmentIndex + 1)!
        
        let chartData: ChartData = EntryHistorian.getChartData(for: tf)
        
        // Bottom X labels
        var bottomXLabels: [String] = []
        let startDate = chartData.startDate
        let dataTimeFrame = chartData.dataTimeFrame
        var currentDate = startDate
        for i in 0..<chartData.size {
            switch dataTimeFrame {
            case .day:
                currentDate.day! += 1
            case .week:
                currentDate.weekOfYear! += 1
            case .month:
                currentDate.month! += 1
            case .quarter:
                currentDate.month! += 3
            case .year:
                currentDate.year! += 1
            default:
                break
            }
        }
        
        // Top X Labels
        var topXLabels: [String] = []
        
        chart.configure(yValues: chartData.data, bottomXLabels: bottomXLabels, topXLabels: topXLabels)
    }

}

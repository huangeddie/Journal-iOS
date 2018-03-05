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
        let calendarComponent: Calendar.Component
        switch timeFrame.selectedSegmentIndex {
        case 0:
            calendarComponent = .weekOfMonth
        case 1:
            calendarComponent = .month
        case 2:
            calendarComponent = .quarter
        case 3:
            calendarComponent = .year
        default:
            calendarComponent = .calendar
        }
        
        let chartData: ChartData = EntryHistorian.getChartData(for: calendarComponent)
        
        let calendar = Calendar.current
        let startDate = chartData.startDate.date!
        let dataTimeFrame = chartData.dataCalendarComponent
        
        // Bottom X labels
        var bottomXLabels: [String] = []
        if dataTimeFrame != .calendar {
            var currentDate: Date
            for i in 0..<chartData.size {
                currentDate = calendar.date(byAdding: dataTimeFrame, value: i, to: startDate)!
                let componentValue = calendar.component(dataTimeFrame, from: currentDate)
                bottomXLabels.append("\(componentValue)")
            }
        }
        
        
        // Top X Label
        let higherComponent: Calendar.Component = dataTimeFrame.higherComponent
        let higherComponentValue = calendar.component(higherComponent, from: startDate)
        let xLabel: String
        let df = DateFormatter()
        switch higherComponent {
        case .weekOfMonth:
            xLabel = df.weekdaySymbols[higherComponentValue]
        case .month:
            xLabel = df.standaloneMonthSymbols[higherComponentValue]
        case .year:
            xLabel = "\(higherComponentValue)"
        case .calendar:
            xLabel = "All"
        default:
            xLabel = ""
        }
        
        chart.configure(yValues: chartData.data, bottomXLabels: bottomXLabels, topXLabel: xLabel)
    }

}

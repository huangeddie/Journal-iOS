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
        let dataComponent = chartData.dataComponent
        let df = DateFormatter()
        
        // Bottom X labels
        var bottomXLabels: [String] = []
        if dataComponent != .calendar {
            var currentDate: Date
            for i in 0..<chartData.size {
                currentDate = calendar.date(byAdding: dataComponent, value: i, to: startDate)!
                let componentValue = calendar.component(dataComponent, from: currentDate)
                let s: String
                switch dataComponent {
                case .month:
                    if calendarComponent == .year {
                        s = df.shortMonthSymbols[componentValue - 1]
                    } else {
                        s = df.monthSymbols[componentValue - 1]
                    }
                case .weekday:
                    s = df.shortWeekdaySymbols[componentValue - 1]
                case .weekOfMonth:
                    s = "W\(componentValue - 1)"
                default:
                    s = "\(componentValue)"
                }
                bottomXLabels.append(s)
            }
        }
        
        
        // Top X Label
        let higherComponent: Calendar.Component = dataComponent.higherComponent
        let higherComponentValue = calendar.component(higherComponent, from: startDate)
        var xLabel: String
        switch higherComponent {
        case .month:
            let startDay = calendar.component(.day, from: startDate)
            let endDate = calendar.date(byAdding: dataComponent, value: chartData.size, to: startDate)!
            let endDay = calendar.component(.day, from: endDate)
            let endMonth = calendar.component(.month, from: endDate)
            
            let startMonthString = df.standaloneMonthSymbols[higherComponentValue]
            let endMonthString = df.standaloneMonthSymbols[endMonth]
            xLabel = "\(startMonthString) \(startDay) - \(endMonthString) \(endDay)"
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

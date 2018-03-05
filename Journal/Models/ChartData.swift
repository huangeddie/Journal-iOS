//
//  ChartData.swift
//  Journal
//
//  Created by Eddie Huang on 3/4/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

struct ChartData {
    let startDate: DateComponents
    let dataCalendarComponent: Calendar.Component
    var data: [Int]
    
    var size: Int {
        return data.count
    }
    
    init(startDate: DateComponents, dataCalendarComponent: Calendar.Component, data: [Int]? = nil) {
        self.startDate = startDate
        self.dataCalendarComponent = dataCalendarComponent
        self.data = data ?? []
    }
}

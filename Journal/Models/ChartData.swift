//
//  ChartData.swift
//  Journal
//
//  Created by Eddie Huang on 3/4/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

struct ChartData {
    let startDate: Date
    let dataComponent: Calendar.Component
    var data: [Int]
    
    var size: Int {
        return data.count
    }
    
    init(startDate: Date, dataComponent: Calendar.Component, data: [Int]? = nil) {
        self.startDate = startDate
        self.dataComponent = dataComponent
        self.data = data ?? []
    }
}

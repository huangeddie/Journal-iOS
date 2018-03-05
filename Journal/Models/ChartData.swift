//
//  ChartData.swift
//  Journal
//
//  Created by Eddie Huang on 3/4/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

struct ChartData {
    var startDate: Date
    var sectionTimeComponent: DateComponents
    var data: [Int]
    
    init(startDate: Date, sectionTimeComponent: DateComponents, data: [Int]? = nil) {
        self.startDate = startDate
        self.sectionTimeComponent = sectionTimeComponent
        if let data = data {
            self.data = data
        } else {
            self.data = []
        }
    }
}

//
//  ChartData.swift
//  Journal
//
//  Created by Eddie Huang on 3/4/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

struct ChartData {
    var startDate: DateComponents
    var dataTimeFrame: TimeFrame
    var data: [Int]
    
    var size: Int {
        return data.size
    }
    
    init(startDate: DateComponents, data: [Int]? = nil) {
        self.startDate = startDate
        self.data = data ?? []
    }
}

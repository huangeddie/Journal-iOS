//
//  TimeFrame.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

enum TimeFrame: Int {
    case week, month, quarter, year, all
    var estimatedNumberOfDays: Int {
        switch self {
        case .week:
            return 7
        case .month:
            return 30
        case .quarter:
            return 90
        case .year:
            return 365
        default:
            return Int.max
        }
    }
    
    var estimatedNumberOfWeeks: Int {
        switch self {
        case .week:
            return 1
        case .month:
            return 5
        case .quarter:
            return 13
        case .year:
            return 52
        default:
            return Int.max
        }
    }
}

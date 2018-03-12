//
//  CalendarComponent.swift
//  Journal
//
//  Created by Eddie Huang on 3/4/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

extension Calendar.Component {
    var higherComponent: Calendar.Component {
        switch self {
        case .calendar:
            return .calendar
        case .day, .weekday, .weekdayOrdinal, .weekOfMonth, .weekOfYear:
            return .month
        case .month, .quarter:
            return .year
        case .year:
            return .calendar
        default:
            return .calendar
        }
    }
    
    var lowerComponent: Calendar.Component {
        switch self {
        case .calendar:
            return .year
        case .year, .quarter:
            return .month
        case .month:
            return .weekOfYear
        case .weekOfMonth, .weekOfYear:
            return .weekday
        default:
            return self
        }
    }
}

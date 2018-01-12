//
//  DateFormatter.swift
//  Journal
//
//  Created by Edward Huang on 1/11/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var RFC3339DateFormatter: DateFormatter {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        df.timeZone = TimeZone(secondsFromGMT: 0)
        return df
    }
}



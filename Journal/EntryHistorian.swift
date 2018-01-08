//
//  EntryHistorian.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

class EntryHistorian {
    var timeFrame: TimeFrame!
    
    private var entries: [Entry] = []
    
    init(timeFrame: TimeFrame) {
        self.timeFrame = timeFrame
    }
}

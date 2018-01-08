//
//  EntryHistorian.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

class EntryHistorian {
    // MARK: Properties
    var timeFrame: TimeFrame {
        didSet {
            updateEntries()
        }
    }
    
    private var entries: [Entry] = []
    
    // MARK: Initialization
    init(timeFrame: TimeFrame) {
        self.timeFrame = timeFrame
        updateEntries()
    }
    
    // MARK: Public functions
    func getEntries(for timeFrame: TimeFrame) -> [Entry]{
        self.timeFrame = timeFrame
        updateEntries()
        
        return entries
    }
    
    // MARK: Private functions
    private func updateEntries() {
        // TODO: update the entries
    }
}

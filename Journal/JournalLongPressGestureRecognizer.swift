//
//  JournalLongPressGestureRecognizer.swift
//  Journal
//
//  Created by Edward Huang on 1/29/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation
import UIKit

class JournalLongPressGestureRecognizer: UILongPressGestureRecognizer {
    var journalIndex: Int
    init(index: Int, target: Any?, action: Selector?) {
        journalIndex = index
        super.init(target: target, action: action)
    }
}

//
//  JournalCollectionViewLayout.swift
//  Journal
//
//  Created by Edward Huang on 1/24/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class JournalCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        minimumLineSpacing = 20
        // TODO: Make this dynamic
        itemSize = CGSize(width: 150, height: 120)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        minimumLineSpacing = 20
        itemSize = CGSize(width: 150, height: 120)
    }
}

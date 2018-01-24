//
//  EntryCollectionViewLayout.swift
//  Journal
//
//  Created by Edward Huang on 1/22/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class EntryCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        minimumLineSpacing = 20
        // TODO: Make this dynamic
        itemSize = CGSize(width: 300, height: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        minimumLineSpacing = 20
        itemSize = CGSize(width: 350, height: 200)
    }
}

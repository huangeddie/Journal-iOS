//
//  JournalCollectionViewCell.swift
//  Journal
//
//  Created by Edward Huang on 1/24/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class JournalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view: JournalCollectionViewCellMainView!
    @IBOutlet weak var title: UILabel!
    override func draw(_ rect: CGRect) {
        clipsToBounds = false
        layer.masksToBounds = false
    }
}

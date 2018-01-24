//
//  EntryCollectionView.swift
//  Journal
//
//  Created by Edward Huang on 1/22/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

@IBDesignable
class EntryCollectionView: UICollectionView {

    @IBInspectable
    var topAndBottomContentInsets: CGFloat = 0 {
        didSet {
            contentInset = UIEdgeInsetsMake(topAndBottomContentInsets, sideContentInsets, topAndBottomContentInsets, sideContentInsets)
        }
    }
    
    @IBInspectable
    var sideContentInsets: CGFloat = 0 {
        didSet {
            contentInset = UIEdgeInsetsMake(topAndBottomContentInsets, sideContentInsets, topAndBottomContentInsets, sideContentInsets)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//
//  JournalTableCellMainView.swift
//  Journal
//
//  Created by Edward Huang on 1/22/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

@IBDesignable
class JournalTableCellMainView: UIView {
    
    @IBInspectable
    var shadowRadius: CGFloat = 3 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 1.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 0, height: 5) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func setNeedsDisplay() {
        setup()
    }
    
    private func setup() {
        // Add a shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}

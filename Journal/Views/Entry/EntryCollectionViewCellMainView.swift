//
//  EntryCollectionViewCellMainView.swift
//  Journal
//
//  Created by Edward Huang on 1/22/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

@IBDesignable
class EntryCollectionViewCellMainView: UIView {

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
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    var backColor: UIColor = .white {
        didSet {
            setup()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        setup()
    }
    
    private func setup() {
        
        // Draw background
        let background = UIBezierPath(roundedRect: CGRect(origin: .zero, size: self.frame.size), cornerRadius: cornerRadius)
        backColor.set()
        background.fill()
        
        // Add a shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}

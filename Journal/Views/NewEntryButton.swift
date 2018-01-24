//
//  NewEntryButton.swift
//  Journal
//
//  Created by Edward Huang on 1/22/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

@IBDesignable
class NewEntryButton: UIButton {
    
    @IBInspectable
    var plusWidth: CGFloat = 10 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    var plusSizeToFrameRatio: CGFloat = 0.8 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    var plusColor: UIColor = .white {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    var backColor: UIColor = .black {
        didSet {
            setup()
        }
    }
    
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
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        setup()
    }
    
    // MARK: Private Methods
    fileprivate func setup() {
        // Drawing code
        let length = self.frame.height
        let width = self.frame.width
        
        // Add a circle
        let roundedRectPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: width, height: length)), cornerRadius: cornerRadius)
        backColor.set()
        roundedRectPath.fill()
        
        // Add a plus
        let drawer = UIBezierPath()
        drawer.lineCapStyle = .round
        drawer.lineWidth = plusWidth
        plusColor.set()
        
        // Points for the plus
        let top = CGPoint(x: width/2, y: (length / 2) * (1 - plusSizeToFrameRatio))
        let bottom = CGPoint(x: width/2, y: (length / 2) * (1 + plusSizeToFrameRatio))
        let left = CGPoint(x: (width - plusSizeToFrameRatio * length) / 2, y: length/2)
        let right = CGPoint(x: (width + plusSizeToFrameRatio * length) / 2, y: length/2)
        drawer.move(to: top)
        drawer.addLine(to: bottom)
        
        drawer.move(to: left)
        drawer.addLine(to: right)
        
        drawer.stroke()
        
        // Add a shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}

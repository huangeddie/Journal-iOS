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
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var plusSizeToFrameRatio: CGFloat = 0.8 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var plusColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var backColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
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
        assert(length == self.frame.width)
        
        // Add a circle
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: length, height: length)))
        backColor.set()
        circlePath.fill()
        
        // Add a plus
        let drawer = UIBezierPath()
        drawer.lineCapStyle = .round
        drawer.lineWidth = plusWidth
        plusColor.set()
        
        // Points for the plus
        let top = CGPoint(x: length/2, y: (length / 2) * (1 - plusSizeToFrameRatio))
        let bottom = CGPoint(x: length/2, y: (length / 2) * (1 + plusSizeToFrameRatio))
        let left = CGPoint(x: (length / 2) * (1 - plusSizeToFrameRatio), y: length/2)
        let right = CGPoint(x: (length / 2) * (1 + plusSizeToFrameRatio), y: length/2)
        drawer.move(to: top)
        drawer.addLine(to: bottom)
        
        drawer.move(to: left)
        drawer.addLine(to: right)
        
        drawer.stroke()
        
        // Add a shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}

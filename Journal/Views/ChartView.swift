//
//  ChartView.swift
//  Journal
//
//  Created by Edward Huang on 2/25/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

@IBDesignable
class ChartView: UIView {
    
    var yValues: [Int] = [1,3,2]
    var xLabels: [String] = []
    
    private let bottomOffSet: CGFloat = 15
    private let topOffSet: CGFloat = 15

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let pencil = UIBezierPath()
        
        // Draw a horizontal line at the bottom offset
        var leftPoint = CGPoint(x: 0, y: frame.height - bottomOffSet)
        var rightPoint = CGPoint(x: frame.width, y: leftPoint.y)
        pencil.move(to: leftPoint)
        pencil.addLine(to: rightPoint)
        
        // Draw a horizontal line at the top offset
        leftPoint = CGPoint(x: 0, y: topOffSet)
        rightPoint = CGPoint(x: frame.width, y: topOffSet)
        pencil.move(to: leftPoint)
        pencil.addLine(to: rightPoint)
        
        // Draw lines outlining the left, and right
        let bottomLeft = CGPoint(x: 0, y: frame.height)
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: frame.width, y: 0)
        let bottomRight = CGPoint(x: frame.width, y: frame.height)
        
        pencil.move(to: bottomLeft)
        pencil.addLine(to: topLeft)
        pencil.move(to: topRight)
        pencil.addLine(to: bottomRight)
        
        #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).setStroke()
        pencil.stroke()
        
        
        // Draw the bars
        
        
    }

}

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
    
    private var yValues: [Int] = [1,3,2,2,3,4,0] // There must be at least 2 elements
    private var bottomXLabels: [String] = ["19", "20", "21", "22", "23", "24", "25"] // There must be at least 2 elements
    private var topXLabels: [String] = ["Month"] // There must be at least 1 element and at most bottomXLabels.count elements
    
    private let bottomOffSet: CGFloat = 20
    private let topOffSet: CGFloat = 15
    private let yInterval: Int = 5
    
    func configure(yValues: [Int]? = nil, bottomXLabels: [String]? = nil, topXLabels: [String]? = nil) {
        self.yValues = yValues ?? []
        self.bottomXLabels = bottomXLabels ?? []
        self.topXLabels = topXLabels ?? []
        setNeedsDisplay()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let maxY = yValues.reduce(0) { (localMax, y) -> Int in
            return max(localMax, y)
        }
        let yCapacity = ((maxY + yInterval) / yInterval) * yInterval
        
        // Draw the vertical section lines and labels
        let sectionPath = UIBezierPath()
        let sectionWidth: CGFloat = frame.width / CGFloat(bottomXLabels.count - 1)
        for i in 0..<bottomXLabels.count {
            let xPosition = sectionWidth * CGFloat(i)
            let topPoint = CGPoint(x: xPosition, y: 0)
            let bottomPoint = CGPoint(x: xPosition, y: frame.height)
            sectionPath.move(to: topPoint)
            sectionPath.addLine(to: bottomPoint)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = i < bottomXLabels.count - 1 ? .left : .right
            let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
                              NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 12.0),
                              NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                              ]
            
            let text = bottomXLabels[i]
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            let textHeight = attrString.size().height
            
            let rt = CGRect(x: xPosition - (i < bottomXLabels.count - 1 ? CGFloat(0) : sectionWidth), y: frame.height - textHeight, width: sectionWidth, height: textHeight)
            attrString.draw(in: rt)
            
            if i == bottomXLabels.count - 1 {
                // Max value label
                let attrString = NSAttributedString(string: "\(yCapacity)",
                                                    attributes: attributes)
                let textHeight = attrString.size().height
                let textWidth = attrString.size().width
                
                let rt = CGRect(x: frame.width - textWidth, y: topOffSet, width: textWidth, height: textHeight)
                attrString.draw(in: rt)
            }
        }
        
        #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1).setStroke()
        sectionPath.lineWidth = 1
        sectionPath.stroke()
        
        // Draw the outlines
        let outlinePath = UIBezierPath()
        // Draw a horizontal line at the bottom offset
        var leftPoint = CGPoint(x: 0, y: frame.height - bottomOffSet)
        var rightPoint = CGPoint(x: frame.width, y: leftPoint.y)
        outlinePath.move(to: leftPoint)
        outlinePath.addLine(to: rightPoint)
        
        // Draw a horizontal line at the top offset
        leftPoint = CGPoint(x: 0, y: topOffSet)
        rightPoint = CGPoint(x: frame.width, y: topOffSet)
        outlinePath.move(to: leftPoint)
        outlinePath.addLine(to: rightPoint)
        
        // Draw lines outlining the left, and right
        let bottomLeft = CGPoint(x: 0, y: frame.height)
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: frame.width, y: 0)
        let bottomRight = CGPoint(x: frame.width, y: frame.height)
        
        outlinePath.move(to: bottomLeft)
        outlinePath.addLine(to: topLeft)
        outlinePath.move(to: topRight)
        outlinePath.addLine(to: bottomRight)
        
        #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).setStroke()
        outlinePath.stroke()
        
        
        // Draw the points
        let graphPath = UIBezierPath()
        var graphPoints: [CGPoint] = [] // In case we want to fill in the graph with gradients and what not
        let distanceBetweenGraphPoints: CGFloat = frame.width / CGFloat(yValues.count - 1)
        
        let computeGraphPoint = { (i: Int) -> CGPoint in
            let y = self.yValues[i]
            let proportionalHeight = CGFloat(y) / CGFloat(yCapacity)
            let yPosition = self.frame.height - self.bottomOffSet - proportionalHeight * (self.frame.height - self.bottomOffSet - self.topOffSet)
            let graphPoint = CGPoint(x: distanceBetweenGraphPoints * CGFloat(i), y: yPosition)
            return graphPoint
        }
        
        var graphPoint = computeGraphPoint(0)
        graphPath.move(to: graphPoint)
        graphPoints.append(graphPoint)
        for i in 1..<yValues.count {
            graphPoint = computeGraphPoint(i)
            
            graphPath.addLine(to: graphPoint)
            
            graphPoints.append(graphPoint)
        }
        
        #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).setStroke()
        graphPath.stroke()
        
    }

}

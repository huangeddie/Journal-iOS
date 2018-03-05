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
    
    private var yValues: [Int] = [1,3,2,2,3,4,0] // There must be at least 1 element
    private var bottomXLabels: [String] = ["19", "20", "21", "22", "23", "24", "25"] // There must be at least 1 element
    private var topXLabel: String = "Month"
    
    private let bottomOffSet: CGFloat = 20
    private let topOffSet: CGFloat = 15
    private let yInterval: Int = 5
    
    func configure(yValues: [Int]? = nil, bottomXLabels: [String]? = nil, topXLabel: String? = nil) {
        self.yValues = yValues ?? []
        self.bottomXLabels = bottomXLabels ?? []
        self.topXLabel = topXLabel ?? ""
        setNeedsDisplay()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let maxY = yValues.reduce(0) { (localMax, y) -> Int in
            return max(localMax, y)
        }
        let yCapacity = ((maxY + yInterval) / yInterval) * yInterval
        let sectionWidth: CGFloat = frame.width / CGFloat(yValues.count)
        var graphPoints: [CGPoint] = [] // In case we want to fill in the graph with gradients and what not
        
        let drawBars = {
            // Draw the bars
            let graphPath = UIBezierPath()
            
            let computeBarPoints = { (i: Int) -> (CGPoint, CGPoint) in
                let y = self.yValues[i]
                let proportionalHeight = CGFloat(y) / CGFloat(yCapacity)
                let yPosition = self.frame.height - self.bottomOffSet - proportionalHeight * (self.frame.height - self.bottomOffSet - self.topOffSet)
                let p1 = CGPoint(x: sectionWidth * CGFloat(i), y: yPosition)
                let p2 = CGPoint(x: sectionWidth * CGFloat(i) + sectionWidth, y: yPosition)
                return (p1, p2)
            }
            
            
            for i in 0..<self.yValues.count {
                let points = computeBarPoints(i)
                
                graphPath.move(to: points.0)
                graphPath.addLine(to: points.1)
                
                graphPoints.append(points.0)
                graphPoints.append(points.1)
            }
            
            #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).setStroke()
            graphPath.stroke()
        }
        drawBars()
        
        // Draw the gradient
        let drawGradient = {
            // 1 - save the state of the context (commented out for now)
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            
            // 2 - make a clipping path
            let clippingPath = UIBezierPath()
            clippingPath.move(to: CGPoint(x: 0, y: self.frame.height))
            for point in graphPoints {
                clippingPath.addLine(to: point)
            }
            clippingPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
            
            // 3 - close it
            clippingPath.close()
            
            // 4 - add the clipping path to the context
            clippingPath.addClip()
            
            // 5 - gradient
            let colorSpace = CGColorSpaceCreateDeviceGray()
            let colorLocations:[CGFloat] = [0.0, 1.0]
            let colors = [#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor, #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor]
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
            
            let startPoint = CGPoint(x: 0, y: self.topOffSet)
            let endPoint = CGPoint(x: 0, y: self.frame.height - self.bottomOffSet)
            
            context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
            context?.restoreGState()
        }
        drawGradient()
        
        let drawOutLines = {
            // Draw the outlines
            let outlinePath = UIBezierPath()
            // Draw a horizontal line at the bottom offset
            var leftPoint = CGPoint(x: 0, y: self.frame.height - self.bottomOffSet)
            var rightPoint = CGPoint(x: self.frame.width, y: leftPoint.y)
            outlinePath.move(to: leftPoint)
            outlinePath.addLine(to: rightPoint)
            
            // Draw a horizontal line at the top offset
            leftPoint = CGPoint(x: 0, y: self.topOffSet)
            rightPoint = CGPoint(x: self.frame.width, y: self.topOffSet)
            outlinePath.move(to: leftPoint)
            outlinePath.addLine(to: rightPoint)
            
            // Draw lines outlining the left, and right
            let bottomLeft = CGPoint(x: 0, y: self.frame.height)
            let topLeft = CGPoint(x: 0, y: 0)
            let topRight = CGPoint(x: self.frame.width, y: 0)
            let bottomRight = CGPoint(x: self.frame.width, y: self.frame.height)
            
            outlinePath.move(to: bottomLeft)
            outlinePath.addLine(to: topLeft)
            outlinePath.move(to: topRight)
            outlinePath.addLine(to: bottomRight)
            
            #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).setStroke()
            outlinePath.stroke()
        }
        drawOutLines()
        
        let drawVerticalLinesAndLabels = {
            // Draw the vertical section lines and labels
            let sectionPath = UIBezierPath()
            for i in 0..<self.bottomXLabels.count {
                let xPosition = sectionWidth * CGFloat(i)
                let topPoint = CGPoint(x: xPosition, y: self.topOffSet)
                let bottomPoint = CGPoint(x: xPosition, y: self.frame.height)
                sectionPath.move(to: topPoint)
                sectionPath.addLine(to: bottomPoint)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
                                  NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 12.0),
                                  NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                                  ]
                
                let text = self.bottomXLabels[i]
                let attrString = NSAttributedString(string: text,
                                                    attributes: attributes)
                let textHeight = attrString.size().height
                
                let rt = CGRect(x: xPosition, y: self.frame.height - textHeight, width: sectionWidth, height: textHeight)
                attrString.draw(in: rt)
            }
            
            #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1).setStroke()
            sectionPath.lineWidth = 1
            sectionPath.stroke()
        }
        drawVerticalLinesAndLabels()
        
        // Top x label
        let drawTopXLabel = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
                              NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 12.0),
                              NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                              ]
            let attrString = NSAttributedString(string: self.topXLabel,
                                                attributes: attributes)
            let textHeight = attrString.size().height
            let textWidth = attrString.size().width
            
            let rt = CGRect(x: 5, y: self.topOffSet - textHeight, width: textWidth, height: textHeight)
            attrString.draw(in: rt)
        }
        drawTopXLabel()
        
        // Max value label
        let drawMaxValue = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
                              NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 12.0),
                              NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                              ]
            let maxAttrString = NSAttributedString(string: "\(yCapacity)",
                attributes: attributes)
            let maxTextHeight = maxAttrString.size().height
            let maxTextWidth = maxAttrString.size().width
            
            let rt = CGRect(x: self.frame.width - maxTextWidth - 5, y: self.topOffSet - maxTextHeight, width: maxTextWidth, height: maxTextHeight)
            maxAttrString.draw(in: rt)
        }
        drawMaxValue()
    }
}

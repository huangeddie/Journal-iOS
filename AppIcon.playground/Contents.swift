//: Playground - noun: a place where people can play

import UIKit
import XCPlayground


func createImageIcon(resolution: Double, multiplier: Int) -> UIImage {
    
    let bookmarkProportionalWidth: CGFloat = 0.3
    let bookmarkProportionalXPosition: CGFloat = 0.6
    let bookmarkColor = #colorLiteral(red: 0.1372230551, green: 0.1590512935, blue: 0.1866094136, alpha: 1)
    
    let frameLength: CGFloat = CGFloat(resolution * Double(multiplier) / 2)
    
    let imageSize = CGSize(width: frameLength, height: frameLength)
    
    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    
    let background = CGRect(origin: .zero, size: imageSize)
    let topBackgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    let bottomBackgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    
    context?.saveGState()
    let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [topBackgroundColor.cgColor, bottomBackgroundColor.cgColor] as CFArray, locations: [0, 1])
    context?.drawLinearGradient(gradient!, start: CGPoint.init(x: frameLength/2, y: 0) , end: CGPoint(x: frameLength/2, y: frameLength), options: CGGradientDrawingOptions(rawValue: 0))
    context?.restoreGState()
    
    let bookmarkRect = CGRect(x: frameLength * bookmarkProportionalXPosition, y: 0, width: bookmarkProportionalWidth * frameLength, height: frameLength)
    
    let bookmarkPath = UIBezierPath(rect: bookmarkRect)
    
    bookmarkColor.setFill()
    bookmarkPath.fill()
    
    
    // This code must always be at the end of the playground
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    
    return image
}


let resolutions = [20, 29, 40, 60, 76, 83.5]

for resolution in resolutions {
    for mult in 1...3 {
        let icon = createImageIcon(resolution: resolution, multiplier: mult)
        let resolutionString: String
        if Int(resolution * 10) % 10 == 0 {
            resolutionString = "\(Int(resolution))"
        } else {
            resolutionString = "\(resolution)"
        }
        
        let multString: String
        if mult > 1 {
            multString = "@\(mult)x"
        } else {
            multString = ""
        }
        
        let fileName = "appIcon-\(resolutionString)\(multString).png"
        let fileURL = XCPlaygroundSharedDataDirectoryURL.appendingPathComponent(fileName)!
        
        do {
            try UIImagePNGRepresentation(icon)?.write(to: fileURL)
        } catch {
            print(error)
        }
    }
}







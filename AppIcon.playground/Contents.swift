//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import PlaygroundSupport

func createImageIcon(resolution: Double, multiplier: Int) -> UIImage {
    
    let bookmarkProportionalWidth: CGFloat = 0.3
    let bookmarkProportionalXPosition: CGFloat = 0.6
    let bookmarkColor = #colorLiteral(red: 0.1372230551, green: 0.1590512935, blue: 0.1866094136, alpha: 1)
    
    let frameLength: CGFloat = CGFloat(resolution * Double(multiplier) / 2)
    
    let imageSize = CGSize(width: frameLength, height: frameLength)
    
    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    
    let topBackgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    let bottomBackgroundColor = #colorLiteral(red: 0.3712273365, green: 0.4004876047, blue: 0.4451599608, alpha: 1)
    
    context?.saveGState()
    let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [topBackgroundColor.cgColor, bottomBackgroundColor.cgColor] as CFArray, locations: [0.3, 1])
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

func createAndWriteImageIcon(resolution: Double, mult: Int) {
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
    let fileURL = playgroundSharedDataDirectory.appendingPathComponent(fileName)
    
    do {
        try UIImagePNGRepresentation(icon)?.write(to: fileURL)
    } catch {
        print(error)
    }
}

for resolution in resolutions {
    for mult in 1...3 {
        createAndWriteImageIcon(resolution: resolution, mult: mult)
    }
}
createAndWriteImageIcon(resolution: 1024, mult: 1)







//
//  UIImage.swift
//  Eyesistant
//
//  Created by Dharmawan Ruslan on 21/08/24.
//

import Foundation
import UIKit

extension UIImage{
    func tintPhoto(_ tintColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // Draw original image
            context.setBlendMode(.normal)
            context.draw(cgImage!, in: rect)
            
            // Tint the image while preserving the original image's luminosity and transparency
            context.setBlendMode(.multiply)
            tintColor.setFill()
            context.fill(rect)
            
            // Restore alpha channel from the original image
            context.setBlendMode(.destinationIn)
            context.draw(cgImage!, in: rect)
        }
    }
    
    fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage {
        
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

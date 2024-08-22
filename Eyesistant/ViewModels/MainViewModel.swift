//
//  MainViewModel.swift
//  Eyesistant
//
//  Created by Dharmawan Ruslan on 22/08/24.
//

import Foundation
import UIKit

class MainViewModel: ObservableObject{
    func applyChromaKeyFilter(to inputImage: CIImage, targetRed: CGFloat, targetGreen: CGFloat, targetBlue: CGFloat, tolerance: CGFloat) -> CIImage? {
        let size = 32 // Reduced size for performance
        var cubeRGB = [Float]()
        
        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size - 1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size - 1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size - 1)
                    
                    let isInRange = abs(red - targetRed) <= tolerance &&
                    abs(green - targetGreen) <= tolerance &&
                    abs(blue - targetBlue) <= tolerance
                    
                    if isInRange {
                        cubeRGB.append(Float(red))
                        cubeRGB.append(Float(green))
                        cubeRGB.append(Float(blue))
                        cubeRGB.append(1.0) // Full opacity
                    } else {
                        let gray = (red + green + blue) / 3.0
                        cubeRGB.append(Float(gray))
                        cubeRGB.append(Float(gray))
                        cubeRGB.append(Float(gray))
                        cubeRGB.append(1.0) // Full opacity
                    }
                }
            }
        }
        
        // Create the CIColorCube filter
        let colorCubeFilter = CIFilter.colorCube()
        colorCubeFilter.cubeDimension = Float(size)
        colorCubeFilter.cubeData = Data(bytes: cubeRGB, count: cubeRGB.count * 4)
        
        // Apply the color cube filter to the input image
        colorCubeFilter.inputImage = inputImage
        
        // Get the filtered image output
        return colorCubeFilter.outputImage
    }
}

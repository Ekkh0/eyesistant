//
//  SkinToneDetection.swift
//  Eyesistant
//
//  Created by Dharmawan Ruslan on 19/08/24.
//

import UIKit
import Vision
import CoreImage

class SkinToneDetection: ObservableObject {
    var detectedFaceLandmarks: VNFaceObservation?
    var averageColorResult: UIColor?

    func detectSkinTone(in image: UIImage) -> Int{
        guard let cgImage = image.cgImage else {
            print("Unable to create CGImage.")
            return 0
        }

        let request = VNDetectFaceLandmarksRequest { (request, error) in
            if let error = error {
                print("Face landmarks detection error: \(error)")
                return
            }
            guard let results = request.results as? [VNFaceObservation], let detectedFace = results.first else {
                print("No face detected")
                return
            }
            
            var regionColors:[UIColor] = []

            self.detectedFaceLandmarks = detectedFace
            if let medianLine = detectedFace.landmarks?.medianLine{
                for (index, point) in medianLine.normalizedPoints.enumerated(){
                    if index==4{
                        break
                    }
                    if let faceImage = self.cropRegion(image: image, point: point, boundingBox: detectedFace.boundingBox) {
                        let skinColors = self.extractSkinPixels(from: faceImage)
                        regionColors.append(self.averageColor(colors: skinColors)!)
                    }
                }
            }
            self.averageColorResult = self.averageColor(colors: regionColors)
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform face landmarks detection: \(error)")
        }
        
        if let skinType = skinToneClassifier(color: self.averageColorResult){
            return skinType
        } else {
            return 0
        }
    }
    
    func skinToneClassifier(color: UIColor?) -> Int?{
        if let color = color{
            let ryb = rgbToRyb(red: color.redValue*255, green: color.greenValue*255, blue: color.blueValue*255)
            let hsv = rgbToHsv(r: color.redValue, g: color.greenValue, b: color.blueValue)
            print(hsv.s)
            print(color.redValue, color.greenValue, color.blueValue)
            print(ryb)
            if ryb.rybYellow == max(ryb.rybBlue, ryb.rybRed, ryb.rybYellow) || (ryb.rybYellow-15...ryb.rybYellow+15 ~= color.redValue*255 && ryb.rybBlue != max(ryb.rybBlue, ryb.rybRed, ryb.rybYellow)){
                if hsv.s > 0.5{
                    return 1
                }else {
                    return 2
                }
            }else{
                if hsv.s > 0.5{
                    return 3
                }else {
                    return 4
                }
            }
        }
        return 0
    }

    func cropRegion(image: UIImage, point: CGPoint, boundingBox: CGRect) -> UIImage? {

        guard let cgImage = image.cgImage else {
            print("Can't get cgimage")
            return nil
        }
        
        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)
        
        let croppedWidth = 0.1 * imageWidth
        let croppedHeight = 0.1 * imageWidth
        let x = boundingBox.origin.x * imageWidth + point.x * imageWidth * boundingBox.width - croppedWidth/2
        let y = (1 - boundingBox.origin.y) * imageHeight - point.y * imageHeight * boundingBox.height - croppedHeight/2
        let rect = CGRect(
            x: x,
            y: y,
            width: croppedWidth,
            height: croppedHeight
        )

        guard let croppedCgImage = cgImage.cropping(to: rect) else {
            print("Failed to crop eye region")
            return nil
        }

        return UIImage(cgImage: croppedCgImage)
    }

    func extractSkinPixels(from image: UIImage) -> [UIColor] {
        guard let cgImage = image.cgImage else {
            print("Failed to get CGImage from UIImage")
            return []
        }

        let width = cgImage.width
        let height = cgImage.height

        guard let data = cgImage.dataProvider?.data,
              let ptr = CFDataGetBytePtr(data) else {
            print("Failed to get image data")
            return []
        }

        var skinColors: [UIColor] = []

        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (width * y + x) * 4
                let r = CGFloat(ptr[pixelIndex]) / 255.0
                let g = CGFloat(ptr[pixelIndex + 1]) / 255.0
                let b = CGFloat(ptr[pixelIndex + 2]) / 255.0

                skinColors.append(UIColor(red: r, green: g, blue: b, alpha: 1.0))
            }
        }

        if skinColors.isEmpty {
            print("No colors detected")
        }

        return skinColors
    }

    func averageColor(colors: [UIColor]) -> UIColor? {
        guard !colors.isEmpty else { return nil }

        var redTotal: CGFloat = 0
        var greenTotal: CGFloat = 0
        var blueTotal: CGFloat = 0
        var alphaTotal: CGFloat = 0

        for color in colors {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            redTotal += red
            greenTotal += green
            blueTotal += blue
            alphaTotal += alpha
        }

        let count = CGFloat(colors.count)
        return UIColor(
            red: redTotal / count,
            green: greenTotal / count,
            blue: blueTotal / count,
            alpha: alphaTotal / count
        )
    }

    func rgbToHsv(r: CGFloat, g: CGFloat, b: CGFloat) -> (h: CGFloat, s: CGFloat, v: CGFloat) {
        let maxV = max(r, g, b)
        let minV = min(r, g, b)
        let delta = maxV - minV

        var h: CGFloat = 0
        var s: CGFloat = 0
        let v: CGFloat = maxV

        if maxV != 0 {
            s = delta / maxV
        } else {
            s = 0
            h = -1
            return (h, s, v)
        }

        if delta == 0 {
            h = 0 // If there's no color difference, it's gray (no hue)
        } else {
            if r == maxV {
                h = (g - b) / delta
            } else if g == maxV {
                h = 2 + (b - r) / delta
            } else {
                h = 4 + (r - g) / delta
            }

            h *= 60
            if h < 0 {
                h += 360
            }
        }

        return (h, s, v)
    }

    func rgbToRyb(red: CGFloat, green: CGFloat, blue: CGFloat) -> (rybRed: CGFloat, rybYellow: CGFloat, rybBlue: CGFloat) {
        // Normalize the input values to the range [0, 1]
        var r = red / 255.0
        var g = green / 255.0
        var b = blue / 255.0
        
        // Remove the whiteness from the color
        let w = min(r, g, b)
        r -= w
        g -= w
        b -= w
        
        let mg = max(r, g, b)
        
        // Determine the amount of yellow needed
        var y = min(r, g)
        r -= y
        g -= y
        
        // If there is no blue component, rotate the red towards yellow
        if b > 0 && g > 0 {
            b /= 2.0
            g /= 2.0
        }
        
        // Now max the green and blue components
        y += g
        b += g
        
        // Normalize to the max green and apply whiteness
        let my = max(r, y, b)
        if my > 0 {
            let n = mg / my
            r *= n
            y *= n
            b *= n
        }
        
        r += w
        y += w
        b += w
        
        // Convert back to the range [0, 255]
        r *= 255.0
        y *= 255.0
        b *= 255.0
        
        return (rybRed: r, rybYellow: y, rybBlue: b)
    }
    
    func getLuminosity(sampleBuffer: CMSampleBuffer) -> Double{
        let rawMetadata = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))
                let metadata = CFDictionaryCreateMutableCopy(nil, 0, rawMetadata) as NSMutableDictionary
                let exifData = metadata.value(forKey: "{Exif}") as? NSMutableDictionary
                
                let FNumber : Double = exifData?["FNumber"] as! Double
                let ExposureTime : Double = exifData?["ExposureTime"] as! Double
                let ISOSpeedRatingsArray = exifData!["ISOSpeedRatings"] as? NSArray
                let ISOSpeedRatings : Double = ISOSpeedRatingsArray![0] as! Double
                let CalibrationConstant : Double = 50
                
                let luminosity : Double = (CalibrationConstant * FNumber * FNumber ) / ( ExposureTime * ISOSpeedRatings )
        
        return luminosity
    }
    
    func detectFace(in image: UIImage) -> Bool {
        guard let ciImage = CIImage(image: image) else {
            print("Unable to create CIImage")
            return false
        }
        
        // Create a face detection request
        let faceDetectionRequest = VNDetectFaceRectanglesRequest()
        
        // Create a request handler
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            // Perform the face detection request
            try requestHandler.perform([faceDetectionRequest])
            
            // Check if any faces were detected
            if let results = faceDetectionRequest.results as? [VNFaceObservation] {
                return !results.isEmpty
            } else {
                return false
            }
        } catch {
            print("Failed to perform face detection: \(error.localizedDescription)")
            return false
        }
    }
}

//
//  ImageUtility.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/07/27.
//

import Foundation
import UIKit
import SwiftUI

class ImageUtility {
    
    // image crop function
    static func cropImage(_ image: UIImage, points: [CGPoint]) -> UIImage? {
        let fixedImage = fixOrientation(img: image)
        // 1. Find the bounding box of the points
        let minX = points.min(by: { $0.x < $1.x })?.x ?? 0
        let minY = points.min(by: { $0.y < $1.y })?.y ?? 0
        let maxX = points.max(by: { $0.x < $1.x })?.x ?? 0
        let maxY = points.max(by: { $0.y < $1.y })?.y ?? 0
        let rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        for point in points{
            print("point: \(point)")
        }
        // 2. Crop the image to the bounding box
//        guard let cgImage = image.cgImage?.cropping(to: rect) else { return nil }
        guard let cgImage = fixedImage.cgImage?.cropping(to: rect) else { return nil }
        let croppedImage = UIImage(cgImage: cgImage)
//        return croppedImage
        // 3. Mask the cropped image
        let path = UIBezierPath()
        for (index, point) in points.enumerated() {
            let relativePoint = CGPoint(x: point.x - minX, y: point.y - minY)
            if index == 0 {
                path.move(to: relativePoint)
            } else {
                path.addLine(to: relativePoint)
            }
        }
        path.close()
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        path.addClip()
        croppedImage.draw(at: .zero)
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return maskedImage
    }
    //Converts the point coordinate system in the view to the actual image coordinate system.
    static func convertToImageCoordinates(from points: [CGPoint], for image: UIImage, in geometry: GeometryProxy) -> [CGPoint] {
        let viewSize = geometry.size
        let imageSize = image.size
    
        let ratioY = imageSize.height / viewSize.height
        
        return points.map { CGPoint(x: $0.x * ratioY, y: $0.y * ratioY) }
    }
    static func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == UIImage.Orientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height);
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    static func cropImageByViewRatio(for image: UIImage?, in geometry: GeometryProxy) -> UIImage? {
        guard let image = image else {
            return nil
        }
        let fixedImage = fixOrientation(img: image)
        let viewSize = geometry.size
        let imageSize = fixedImage.size
        
        let ratioY = imageSize.height / viewSize.height
        let cropHeight = imageSize.height
        let cropWidth = viewSize.width * ratioY
        
        let trashWidth = (imageSize.width - cropWidth) / 2
        let rect = CGRect(x: trashWidth, y: 0, width: cropWidth, height: cropHeight)
        
        if let cgImage = fixedImage.cgImage?.cropping(to: rect) {
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
}
extension CGSize {
    static func + (lhs: Self, rhs: Self) -> Self {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}


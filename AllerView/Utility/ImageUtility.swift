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
        guard let cgImage = image.cgImage?.cropping(to: rect) else { return nil }
        let croppedImage = UIImage(cgImage: cgImage)
        
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
        
        let ratioX = imageSize.width / viewSize.width
        let ratioY = imageSize.height / viewSize.height
        
        return points.map { CGPoint(x: $0.x * ratioX-55, y: $0.y * ratioY) }
    }

}
extension CGSize {
    static func + (lhs: Self, rhs: Self) -> Self {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}

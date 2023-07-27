//
//  VisionUtility.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/07/26.
//

import Foundation
import Vision
import UIKit
class VisionUtility {
    
    //OCR Funtion Returns the recognized text and bounding box
    static func recognizeText(in image: UIImage, completion: @escaping ([String], [CGRect]) -> Void) {
            let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])

            // Setup a new request to recognize text.
            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    fatalError("Received invalid observations")
                }

                var recognizedStrings = [String]()
                var frames = [CGRect]()
                for observation in observations {
                    guard let topCandidate = observation.topCandidates(1).first else { continue }
                    
                    recognizedStrings.append(topCandidate.string)
                    frames.append(observation.boundingBox)
                }

                completion(recognizedStrings, frames)
            }

            request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko"]
        request.usesLanguageCorrection = true

            do {
                try requestHandler.perform([request])
            } catch {
                print("Unable to perform the requests: \(error).")
            }
        }
    //OCR Funtion Returns only recognized text
    static func recognizeText(in image: UIImage, completion: @escaping ([String]) -> Void) {
            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                
                let recognizedStrings = observations.compactMap { observation in
                    return observation.topCandidates(1).first?.string
                }
                
                completion(recognizedStrings)
            }
            
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["ko"]
            request.usesLanguageCorrection = true
            
            let requests = [request]
            
            guard let cgImage = image.cgImage else {
                print("Failed to convert UIImage to CGImage.")
                return
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform(requests)
            } catch {
                print("Failed to perform text recognition: \(error)")
            }
        }
    
    static func loadImageFromResource(image: String) -> UIImage{
        return UIImage(named: image)!
    }
}

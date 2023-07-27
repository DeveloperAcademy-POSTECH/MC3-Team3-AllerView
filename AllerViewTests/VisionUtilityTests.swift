//
//  VisionUtilityTests.swift
//  AllerViewTests
//
//  Created by HyunwooPark on 2023/07/26.
//

import Foundation
import XCTest
@testable import AllerView

class VisionUtilityTests: XCTestCase {
    
    var visionUtility: VisionUtility!
    
    override func setUp() {
        super.setUp()
        visionUtility = VisionUtility()
    }
    
    override func tearDown() {
        visionUtility = nil
        super.tearDown()
    }
    
    func testRecognizeText() {
        let expectation = self.expectation(description: "Text Recognition")
        let testImage = VisionUtility.loadImageFromResource(image: "testFinal2")  // Replace "testImage" with the name of an actual image in your assets
        
        VisionUtility.recognizeText(in: testImage) { recognizedStrings in
            print(recognizedStrings)
            XCTAssertFalse(recognizedStrings.isEmpty, "No text was recognized.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadImageFromResource() {
        let testImageName = "testFinal2" // Replace "testImage" with the name of an actual image in your assets
        let loadedImage = VisionUtility.loadImageFromResource(image: testImageName)
        
        XCTAssertNotNil(loadedImage, "The image could not be loaded.")
    }
}

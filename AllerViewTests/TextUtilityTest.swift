//
//  TextUtilityTest.swift
//  AllerViewTests
//
//  Created by HyunwooPark on 2023/08/03.
//

import Foundation
import XCTest
@testable import AllerView

final class TextUtilityTest: XCTestCase {

    
    func testGetJson() throws {
        let originalString = "히히히헤헤호호홓 {\"test\": \"test\"}"
        let resultString = TextUtility.getJson(originalResponse: originalString)
        
        print("JsonString: \(resultString)")
        XCTAssertEqual("{\"test\": \"test\"}", resultString)

    }
    
    

}

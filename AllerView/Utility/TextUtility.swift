//
//  TextUtility.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/08/03.
//

import Foundation

class TextUtility {
    static func getJson(originalResponse: String) -> String {
        guard let startIdx = originalResponse.firstIndex(of: "{") else {
            fatalError()
        }
        guard let endIdx = originalResponse.lastIndex(of: "}") else {
            fatalError()
        }
        return originalResponse.substring(from: startIdx, to: originalResponse.index(endIdx, offsetBy: 1))
    }
}

extension String {
    func substring(from startIndex: Index, to endIndex: Index) -> String {
        guard startIndex >= self.startIndex, endIndex <= self.endIndex, startIndex < endIndex else {
            fatalError("Invalid indices for substring.")
        }
        return String(self[startIndex ..< endIndex])
    }

    func substring(from startIndex: Index, length: Int) -> String {
        let endIndex = index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
        return substring(from: startIndex, to: endIndex)
    }
}

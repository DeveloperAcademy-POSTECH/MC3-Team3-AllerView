//
//  TextUtility.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/08/03.
//

import Foundation

class TextUtility {}

extension String {
    func getJson() -> String {
        guard let startIdx = firstIndex(of: "{") else {
            print("도움!!!! ===")
            print(self)
            return self
        }
        guard let endIdx = lastIndex(of: "}") else {
            print("도움!!!! ===")
            print(self)
            return self
        }
        return substring(from: startIdx, to: index(endIdx, offsetBy: 1))
    }

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

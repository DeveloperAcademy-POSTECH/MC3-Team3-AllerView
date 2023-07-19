//
//  ScanData.swift
//  AllerView
//
//  Created by 관식 on 2023/07/20.
//

import Foundation

struct ScanData: Identifiable {
    var id = UUID()
    let content: String
    
    init(content: String) {
        self.content = content
    }
}

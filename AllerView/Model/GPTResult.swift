//
//  GPTResult.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/24.
//

import Foundation

struct GPTResult {
    let allIngredients: [String]
    let warnIngredients: [String]
    let warnAllergies: [String]
    let unknownIngredients: [String]
}

extension GPTResult {
    static let sampleData: GPTResult = .init(
        allIngredients: ["ing1", "ing2", "ing3", "ing4", "unknown1", "unknown2"],
        warnIngredients: ["ing1", "ing2", "ing3", "ing4"],
        warnAllergies: ["Allergy1", "Allergy2"],
        unknownIngredients: ["unknown1", "unknown2"]
    )
}

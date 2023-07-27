//
//  GPTModel.swift
//  AllerView
//
//  Created by 관식 on 2023/07/27.
//

import Foundation

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}

struct GPTResponse: Codable {
    let avoidIngredients, unidentifiableIngredients, otherIngredients, warningAllergies: [String]

    enum CodingKeys: String, CodingKey {
        case avoidIngredients = "avoid_ingredients"
        case unidentifiableIngredients = "unidentifiable_ingredients"
        case otherIngredients = "other_ingredients"
        case warningAllergies = "warning_allergies"
    }
}

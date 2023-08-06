//
//  Chat.swift
//  AllerView
//
//  Created by 조기연 on 2023/08/03.
//

import Foundation

struct OpenAIChat {
    // MARK: - Commons

    enum Role: String, Codable {
        case system
        case user
        case assistant
    }

    struct Message: Codable {
        let role: Role
        let content: String
    }

    // MARK: - Requests

    struct Request: Codable {
        let model: String
        let messages: [OpenAIChat.Message]
        let temperature: Int
        let top_p: Int
        let max_tokens: Int
    }

    // MARK: - Responses

    struct Response: Codable {
        let choices: [Choice]
    }

    struct Choice: Codable {
        let message: OpenAIChat.Message

        enum CodingKeys: String, CodingKey {
            case message
        }
    }

    struct Content: Codable {
        let warningAllergies, unidentifiableIngredients, allIngredients: [String]

        enum CodingKeys: String, CodingKey {
            case warningAllergies = "allergenic_ingredients"
            case unidentifiableIngredients = "unrecognized_ingredients"
            case allIngredients = "all_ingredients"
        }
    }
}

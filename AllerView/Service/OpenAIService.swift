//
//  OpenAIService.swift
//  AllerView
//
//  Created by 관식 on 2023/07/24.
//

import Alamofire
import SwiftUI

class OpenAIService {
    private let endPointURL = "https://api.openai.com/v1/chat/completions"
    func sendMessage(message: Message) async -> OpenAIChatResponse? {
        let openAIMessage = OpenAIChatMessage(role: message.role, content: message.content)
        let body = OpenAIChatBody(model: "gpt-3.5-turbo-0613", messages: [openAIMessage])

        let headers: HTTPHeaders = [
            "Authorization": "Bearer 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",
        ]
        return try? await AF.request(endPointURL, method: .post, parameters: body, encoder: .json, headers: headers)
            .serializingDecodable(OpenAIChatResponse.self)
            .value
    }
}

extension OpenAIService {
    struct OpenAIChatBody: Encodable {
        let model: String
        let messages: [OpenAIChatMessage]
    }

    struct OpenAIChatMessage: Codable {
        let role: SenderRole
        let content: String
    }

    struct OpenAIChatResponse: Decodable {
        let choices: [OpenAIChatChoice]
    }

    struct OpenAIChatChoice: Decodable {
        let message: OpenAIChatMessage
    }
}

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

    let bundle = Bundle()

    func sendMessage(messages: [OpenAIChat.Message]) async -> OpenAIChat.Response? {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bundle.freeAPIKey)",
        ]

        let body = OpenAIChat.Request(
            model: "gpt-3.5-turbo-0613",
            messages: messages,
            temperature: 0,
            top_p: 0,
            max_tokens: 1024
        )

        return try? await AF.request(endPointURL, method: .post, parameters: body, encoder: .json, headers: headers)
            .serializingDecodable(OpenAIChat.Response.self)
            .value
    }
}

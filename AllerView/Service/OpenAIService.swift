//
//  OpenAIService.swift
//  AllerView
//
//  Created by 관식 on 2023/07/24.
//

import SwiftUI
import Alamofire

class OpenAIService {
    
    private let endPointURL = "https://api.openai.com/v1/chat/completions"
    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        let body = OpenAIChatBody(model: "gpt-3.5-turbo-0613", messages: openAIMessages)
        
        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(Constants.openAIAPIKey)"
        ]
        return try? await AF.request(endPointURL, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}

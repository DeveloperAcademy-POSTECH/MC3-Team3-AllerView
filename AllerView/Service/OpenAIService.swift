//
//  OpenAIService.swift
//  AllerView
//
//  Created by 관식 on 2023/07/24.
//

import Alamofire
import SwiftUI

class OpenAIService {
    let bundle = Bundle()
    private let endPointURL = "https://api.openai.com/v1/chat/completions"
    func sendMessage(message: Message) async -> OpenAIChatResponse? {
        let openAIMessage = OpenAIChatMessage(role: message.role, content: message.content)
        let body = OpenAIChatBody(model: "gpt-3.5-turbo-0613", messages: [openAIMessage])

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bundle.freeAPIKey)",
        ]
        return try? await AF.request(endPointURL, method: .post, parameters: body, encoder: .json, headers: headers)
            .serializingDecodable(OpenAIChatResponse.self)
            .value
    }
}

extension Bundle {
    var freeAPIKey: String {
        guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
            fatalError("Couldn't find file 'SecretKey.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)

        guard let value = plist?.object(forKey: "FreeAPIKey") as? String else {
            fatalError("Couldn't find key 'FreeAPIKey' in 'SecretKey.plist'.")
        }
        return value
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

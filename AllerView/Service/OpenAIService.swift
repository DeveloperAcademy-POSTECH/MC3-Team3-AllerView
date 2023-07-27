//
//  OpenAIService.swift
//  AllerView
//
//  Created by 관식 on 2023/07/24.
//

import SwiftUI
import Alamofire

class OpenAIService {
    
    let bundle = Bundle()
    private let endPointURL = "https://api.openai.com/v1/chat/completions"
    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        let body = OpenAIChatBody(model: "gpt-3.5-turbo-0613", messages: openAIMessages)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bundle.freeAPIKey)"
        ]
        return try? await AF.request(endPointURL, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}

extension Bundle {
    var freeAPIKey: String {
        get {
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
}

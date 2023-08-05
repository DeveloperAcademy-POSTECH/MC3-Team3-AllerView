//
//  GPTViewModel.swift
//  AllerView
//
//  Created by 관식 on 2023/07/24.
//

import SwiftUI

class GPTModel: ObservableObject {
    var allergies: String = ""
    var scannedData: String = ""

    @Published var uiImage: UIImage? = nil
    @Published var gptResponse: OpenAIChat.Content?
    @Published var isFailed: Bool = false

    private var actScript: String {
        "Act like an allergist."
    }

    private var jsonScript: String {
        """
        <ingredients>\(scannedData)<ingredients>
        <allergies>\(allergies)<allergies>

        json을 만들어줘.
        키는 allergenic_ingredients", "all_ingredients", "unrecognized_ingredients"가 있어.
        "allergenic_ingredients"에는 <ingredients>에서 <allergies>를 유발하는 것을 넣어
        "all_ingredients"에는 <ingredients>를 넣어.
        "unrecognized_ingredients"에는 <ingredients>에서 원재료가 아닌 것을 넣어.
        """
    }

    private var translateScript: String {
        """
        영어로 번역해줘.
        """
    }

    private let openAIService = OpenAIService()

    @MainActor
    func sendMessage() {
        let actMessage = OpenAIChat.Message(role: .user, content: actScript)
        let jsonMessage = OpenAIChat.Message(role: .user, content: jsonScript)
        let translateMessage = OpenAIChat.Message(role: .user, content: translateScript)

        Task {
            do {
                let actResponseMessage = try await self.fetchMessage(messages: [actMessage])
                let jsonResponseMessage = try await self.fetchMessage(messages: [actMessage, actResponseMessage, jsonMessage])
                let translateResponseMessage = try await self.fetchMessage(messages: [actMessage, actResponseMessage, jsonMessage, jsonResponseMessage, translateMessage])

                print(actResponseMessage.content)
                print(jsonResponseMessage.content)
                print(translateResponseMessage.content)

                guard let contentData = translateResponseMessage.content.data(using: .utf8) else { fatalError() }
                self.gptResponse = try JSONDecoder().decode(OpenAIChat.Content.self, from: contentData)
            } catch {
                self.isFailed = true
            }
        }
    }

    func setSendProperties(allergies: String, scannedData: String) {
        self.allergies = allergies
        self.scannedData = scannedData
    }

    func clear() {
        uiImage = nil
        gptResponse = nil
        allergies = ""
        scannedData = ""
        isFailed = false
    }

    private func fetchMessage(messages: [OpenAIChat.Message]) async throws -> OpenAIChat.Message {
        let response = await openAIService.sendMessage(messages: messages)
        guard let responseMessage = response?.choices.first?.message else { fatalError() }
        return responseMessage
    }
}

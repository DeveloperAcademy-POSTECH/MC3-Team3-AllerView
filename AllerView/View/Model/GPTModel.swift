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

    private var allergyScript: String {
        """
        <ingredients>\(scannedData)<ingredients>

        <allergies>\(allergies)<allergies>

        1. Act like an allergist.
        2. json을 만들어줘.
        키는 allergenic_ingredients", "all_ingredients", "unrecognized_ingredients"가 있어.
        "allergenic_ingredients"에는 <allergies>를 유발하는 <ingredients>를 넣어.
        "all_ingredients"에는 <ingredients>를 넣어.
        "unrecognized_ingredients"에는 원재료가 아닌 것을 넣어.
        """
    }

    private var translateScript: String {
        "영어로 번역해줘."
    }

    private let openAIService = OpenAIService()

    func sendMessage() {
        let allergyMessage = OpenAIChat.Message(role: .user, content: allergyScript)
        let translateMessage = OpenAIChat.Message(role: .user, content: translateScript)

        Task {
            let tempResponse = await openAIService.sendMessage(messages: [allergyMessage])
            guard let tempMessage = tempResponse?.choices.first?.message else {
                DispatchQueue.main.async {
                    self.isFailed = true
                }
                return
            }

            let response = await openAIService.sendMessage(messages: [allergyMessage, tempMessage, translateMessage])
            guard let result = response?.choices.first?.message.content.getJson().data(using: .utf8) else {
                DispatchQueue.main.async {
                    self.isFailed = true
                }
                return
            }
            
            print("=== temp ===")
            print(tempMessage.content)

            await MainActor.run {
                do {
                    self.gptResponse = try JSONDecoder().decode(OpenAIChat.Content.self, from: result)
                } catch {
                    print(error.localizedDescription)
                    isFailed = true
                }
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
}

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
    @Published var responseData: GPTResponse?
    @Published var isFailed: Bool = false

    func makeRequestScript() -> String {
        return "Here are the ingredient names I have: [\(scannedData)]. Could you please translate them into enlish and check if any of these ingredients might trigger the following allergies: [\(allergies)]? And for an output in English with only JSON format, it might be: {\"all_ingredients\": [\"ingredient1\", \"ingredient2\", \"...\"], \"unidentifiable_ingredients\": [\"unidentifiable ingredient\", \"unidentifiable ingredient\", \"...\"], \"allergenic_ingredients\": [\"triggers allergy1\", \"triggers allergy2\", \"...\"]}. Because I'll use the result in my code directrly, you must print only JSON code in english without any mentions."
    }

    private let openAIService = OpenAIService()

    func sendMessage() {
        let message = Message(id: UUID(), role: .user, content: makeRequestScript(), createAt: Date())

        Task {
            let response = await openAIService.sendMessage(message: message)
            guard let receivedOpenAIMessage = response?.choices.first?.message else {
                print("Had no received message")
                isFailed = true
                return
            }
            let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
            print("==================== GPT Response ====================")
            print(receivedMessage.content)
            print("======================================================")
            await MainActor.run {
                do {
                    self.responseData = try JSONDecoder().decode(GPTResponse.self, from: receivedMessage.content.data(using: .utf8)!)
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
        responseData = nil
        allergies = ""
        scannedData = ""
    }
}

struct GPTResponse: Codable {
    let warningAllergies, unidentifiableIngredients, allIngredients: [String]

    enum CodingKeys: String, CodingKey {
        case warningAllergies = "allergenic_ingredients"
        case unidentifiableIngredients = "unidentifiable_ingredients"
        case allIngredients = "all_ingredients"
    }
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}

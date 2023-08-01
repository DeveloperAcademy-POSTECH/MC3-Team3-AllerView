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

    func makeRequestScript() -> String {
        return "I have a string of food ingredient names, '\(scannedData)', obtained through image recognition scanning. Please translate all items to englsih. However, the data is somewhat inaccurate due to image distortion. I need you to infer and correct it within possible limits. Any ingredients that cannot be identified or are determined not to be food ingredients should be placed in the 'unidentifiable_ingredients' group. The data recognized as food ingredients should be placed in the 'all_ingredients' group. I have a set of allergies '\(allergies)'. From the 'all_ingredients' group, I need you to put the food ingredients that could trigger my allergies into the 'avoid_ingredients' group. Place the dangerous types of allergies I have into the 'warning_allergies' group. I intend to use all the results in the form of a Swift dictionary, so please output in the following format: {\"avoid_ingredients\": [], \"unidentifiable_ingredients\": [], \"all_ingredients\": [], \"warning_allergies\": []}. Since I am going to use the output data directly in the code, please only output the JSON result without any other remarks. Please translate all items to englsih."
    }

    private let openAIService = OpenAIService()

    func sendMessage() {
        let message = Message(id: UUID(), role: .user, content: makeRequestScript(), createAt: Date())

        Task {
            let response = await openAIService.sendMessage(message: message)
            guard let receivedOpenAIMessage = response?.choices.first?.message else {
                print("Had no received message")
                return
            }
            let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
            print(receivedMessage.content + "=======")
            await MainActor.run {
                do {
                    self.responseData = try JSONDecoder().decode(GPTResponse.self, from: receivedMessage.content.data(using: .utf8)!)
                    print(responseData.debugDescription)
                } catch {
                    print(error.localizedDescription)
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
    let avoidIngredients, unidentifiableIngredients, allIngredients, warningAllergies: [String]

    enum CodingKeys: String, CodingKey {
        case avoidIngredients = "avoid_ingredients"
        case unidentifiableIngredients = "unidentifiable_ingredients"
        case allIngredients = "all_ingredients"
        case warningAllergies = "warning_allergies"
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

//
//  GPTViewModel.swift
//  AllerView
//
//  Created by 관식 on 2023/07/24.
//

import SwiftUI

extension GPTView {
    class ViewModel: ObservableObject {
        
        @Published var messages: [Message] = []
        @Published var currentInput: String = ""
        @Published var scannedData: String = "생감자90%(국내산) 혼합식용유(해바라기유(수입산)50% 팜올레인유(말레시아산)50% 토스티스오니온(미국산) 얄라얄라얄랴셩"
        @Published var allergies: String = "potato, orange, sunflower seeds"
        @Published var isLoading: Bool = false
        
        func makeRequestScript(allergies: String, scannedData: String) -> String {
            return "I have \(allergies) allergies. '\(scannedData)' here is the string results for the Korean food ingredients recognized by image recognization. However, there is a distortion in the image, so please correct the incorrectly recognized part if possible. And classify them into three groups so that it does not overlap. The criteria for classification groups are Food Ingredients to watch out for my allergies to 'avoid_ingredients', unidentifiable ingredients to 'unidentifiable_ingredients', and the others to 'other_ingredients'. And one more group, Please make the allergies I have to watch out for because of the ingredients in ‘avoid_ingredients’ into the 'warning allergies' group. Please print the result value as Swift dictionary, the group name as Key, and the ingredients as string array. I'm going to use the printed result right away, so please print only the json result."
        }
        
        private let openAIService = OpenAIService()
        
        func sendMessage() {
            isLoading = true
            let newMessage = Message(id: UUID(), role: .user, content: makeRequestScript(allergies: allergies, scannedData: scannedData), createAt: Date())
            messages.append(newMessage)
            currentInput = ""

            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    return
                }
                let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
                await MainActor.run {
                    messages.append(receivedMessage)
                        
                    let resultData = try? JSONDecoder().decode(GPTResponse.self, from: receivedMessage.content.data(using: .utf8)!)
                    print(resultData.debugDescription)
                    isLoading = false
                }
            }
        }
    }
}

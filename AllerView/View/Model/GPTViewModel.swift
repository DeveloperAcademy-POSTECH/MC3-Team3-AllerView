//
//  GPTViewModel.swift
//  AllerView
//
//  Created by 관식 on 2023/07/24.
//

import SwiftUI

extension GPTView {
    class GPTViewModel: ObservableObject {
        
        @Published var messages: [Message] = []
        @Published var currentInput: String = ""
        @Published var scannedData: String = "[6~8층 /원재료명] 정제수, 기타과당, 탈지분유(국산)(포도당, 구연산, 셀룰로스검, 설탕, 복숭아농축과즙(이스라엘산), 향료 3종, 아스파탐(감미료), 락색소, 정제소금(국(산), 혼합제제(규소수지, 소르비탄지방산에스테르, 정제수), 셀룰로스검, 글리세린지방산에스테르), 유산균(1mL 당(유산균 100만마리 이상) 우유, 복숭아 함유 품목보고번호"
        @Published var allergies: String = "sugar, peach, crab"
        @Published var isLoading: Bool = false
        
        func makeRequestScript(allergies: String, scannedData: String) -> String {
            return "I have a string of food ingredient names, '\(scannedData)', obtained through image recognition scanning. However, the data is somewhat inaccurate due to image distortion. I need you to infer and correct it within possible limits. Any ingredients that cannot be identified or are determined not to be food ingredients should be placed in the 'unidentifiable_ingredients' group. The data recognized as food ingredients should be placed in the 'all_ingredients' group. I have a set of allergies '\(allergies)'. From the 'all_ingredients' group, I need you to put the food ingredients that could trigger my allergies into the 'avoid_ingredients' group. Place the dangerous types of allergies I have into the 'warning_allergies' group. I intend to use all the results in the form of a Swift dictionary, so please output in the following format with english: {\"avoid_ingredients\": [], \"unidentifiable_ingredients\": [], \"all_ingredients\": [], \"warning_allergies\": []}. Since I am going to use the output data directly in the code, please only output the JSON result without any other remarks."
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

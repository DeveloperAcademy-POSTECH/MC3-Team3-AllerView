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
        @Published var scannedData: String = "[6~8층 /원재료명] 정제수, 기타과당, 탈지분유(국산)(포도당, 구연산, 셀룰로스검, 설탕, 복숭아농축과즙(이스라엘산), 향료 3종, 아스파탐(감미료), 락색소, 정제소금(국(산), 혼합제제(규소수지, 소르비탄지방산에스테르, 정제수), 셀룰로스검, 글리세린지방산에스테르), 유산균(1mL 당(유산균 100만마리 이상) 우유, 복숭아 함유 품목보고번호"
        @Published var allergies: String = "sugar, peach, crab"
        @Published var isLoading: Bool = false
        
        func makeRequestScript(allergies: String, scannedData: String) -> String {
            return "'\(scannedData)'. 여기 사진 인식으로 스캔한 음식 원재료명 문자열 데이터가 있어. 그런데 이 데이터는 이미지 왜곡 때문에 부정확한 부분이 있어. 너가 가능한 범위 내에서 유추해서 수정해줘. 그 결과 중 인식되지 않거나 음식이 아니라고 판단되는 원재료는 ‘unidentifiable_ingredients’그룹에 넣어주고, 음식 원재료로 인식되는 데이터를 ‘all_ingredients’ 그룹에 넣어줘. 그리고 나는 '\(allergies)' 알러지들을 갖고 있는데, 그 ‘all_ingredients’ 중에서 내가 주의해야하는 알러지를 유발할 수 있는 음식 원재료들을 ‘avoid_ingredients’그룹에 넣어줘. 내가 갖고 있는 알러지들 중 위험한 알러지 종류를 ‘warning_allergies’그룹에 넣어줘. 모든 결과는 swift의 딕셔너리 형태로 사용하려고 하는데, 다음과 같은 포맷을 따라서 뽑아줘. {\"avoid_ingredients\": [], \"unidentifiable_ingredients\": [], \"all_ingredients\": [], \"warning_allergies\": []}. 모든 결과는 영어로 출력해줘. 출력한 데이터를 바로 코드에 바로 사용할 거기 때문에 다른 말은 하지말고 json 결과만 출력해줘."
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

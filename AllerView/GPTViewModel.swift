//
//  GPTViewModel.swift
//  AllerView
//
//  Created by 관식 on 2023/07/24.
//

import SwiftUI

extension GPTView {
    class ViewModel: ObservableObject {
        @Published var message: [Message] = []
        
        func sendMessage() {
            
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}

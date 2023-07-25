//
//  GPTView.swift
//  AllerView
//
//  Created by 관식 on 2023/07/24.
//

import SwiftUI

struct GPTView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                    HStack {
                        if message.role == .user { Spacer() }
                        Text(message.content)
                        if message.role == .assistant { Spacer() }
                    }
                    .padding(.vertical)
                }
            }
            HStack {
                TextField("enter a messages...", text: $viewModel.currentInput)
                Button {
                    viewModel.sendMessage()
                } label: {
                    Text("Send")
                }

            }
        }
        .padding()
    }
}

struct GPTView_Previews: PreviewProvider {
    static var previews: some View {
        GPTView()
    }
}

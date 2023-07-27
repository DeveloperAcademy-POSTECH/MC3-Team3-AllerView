//
//  ProductDetailView.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/13.
//

import SwiftUI
import WrappingHStack

// MARK: - Property

struct AllergyDetailView {
    @ObservedObject var gptModel: GPTModel

    let imageUrl: String
    let gptResult: GPTResult
}

// MARK: - View

extension AllergyDetailView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                // Background Color
                Color.blueGray
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        AsyncImage(
                            url: URL(string: imageUrl),
                            content: { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: proxy.size.width)
                            },
                            placeholder: { ProgressView() }
                        )
                        .padding(.horizontal, -25)
                        .padding(.bottom, 12)

                        DetailHeader()

                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.white)
                            if let responseData = gptModel.responseData {
                                VStack(alignment: .leading) {
                                    Text("There is ")
                                    WrappingHStack(responseData.avoidIngredients, id: \.self) { avoidIngredients in
                                        Chip(name: avoidIngredients, height: 29, isRemovable: false, chipColor: .deepOrange, fontSize: 20, fontColor: .black)
                                    }
                                    
                                    Text("watch out for")
                                    WrappingHStack(responseData.warningAllergies, id: \.self) { warnAllergy in
                                        Chip(name: warnAllergy, height: 29, isRemovable: false, chipColor: .orange, fontSize: 20, fontColor: .white)
                                    }

                                    Divider()

                                    Text("More Ingredient")
                                    WrappingHStack(responseData.allIngredients, id: \.self) { ingredient in
                                        Text(ingredient)
                                            .font(.customBody)
                                            .foregroundColor(gptResult.warnIngredients.contains(where: { $0 == ingredient }) ? .deepOrange : .black)
                                    }
                                }
                                .font(.customHeadline)
                                .padding(20)
                            } else {
                                ProgressView()
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Componenets

extension AllergyDetailView {
    func DetailHeader() -> some View {
        HStack {
            Image("AIHead")
            Text("AI Summary")

            Spacer()

            Button {
                gptModel.responseData = nil
                gptModel.sendMessage()
            } label: {
                Circle()
                    .foregroundColor(.white)
                    .scaledToFit()
                    .frame(width: 40)
                    .overlay {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.blue)
                    }
            }
        }
    }
}

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
                        if let uiImage = gptModel.uiImage {
                            let croppedImage = ImageUtility.cropImageToSquare(for: uiImage, in: proxy)
                            Image(uiImage: croppedImage!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width)
                                .padding(.horizontal, -25)
                                .padding(.bottom, 12)
                        }

                        DetailHeader()
                        DetailBody()
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
                .foregroundColor(.defaultGray)

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

    func DetailBody() -> some View {
        ZStack {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .frame(width: 50, height: 50)
                RoundedRectangle(cornerRadius: 20)
            }
            .foregroundColor(.white)

            if let responseData = gptModel.responseData {
                VStack(alignment: .leading, spacing: 20) {
                    if !responseData.warningAllergies.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.bubble")
                                Text("Attention")
                            }
                            .font(.system(size: 20, weight: .bold))

                            Text("This ingredients")
                                .font(.system(size: 20, weight: .medium))
                            WrappingHStack(responseData.avoidIngredients, id: \.self) { avoidIngredients in
                                Chip(name: avoidIngredients, height: 29, isRemovable: false, chipColor: .lightYellow, fontSize: 17, fontColor: .deepOrange)
                                    .fontWeight(.medium)
                                    .padding(.bottom, 4)
                            }

                            Text("matches your allergies")
                                .font(.system(size: 20, weight: .medium))
                            WrappingHStack(responseData.warningAllergies, id: \.self) { warnAllergy in
                                Chip(name: warnAllergy, height: 29, isRemovable: false, chipColor: .deepOrange, fontSize: 17, fontColor: .white)
                                    .fontWeight(.medium)
                                    .padding(.bottom, 4)
                            }
                        }

                        if !responseData.unidentifiableIngredients.isEmpty {
                            Divider()

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Unidentifiable Ingredients")
                                    .font(.system(size: 17, weight: .semibold))
                                WrappingHStack(responseData.unidentifiableIngredients, id: \.self, spacing: .constant(16)) { ingredient in
                                    Text(ingredient)
                                        .font(.system(size: 17))
                                        .padding(.bottom, 2)
                                }
                                .foregroundColor(.defaultGray)
                                HStack(spacing: 4) {
                                    Image(systemName: "questionmark.square.dashed")
                                    Text("You can refresh or retake.")
                                }
                                .foregroundColor(.lightGray1)
                            }
                        }
                    } else {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal.fill")
                            Text("Free of allergies.")
                                .font(.system(size: 17, weight: .medium))
                        }
                        .foregroundColor(.green)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("All Ingredients")
                            .font(.system(size: 17, weight: .semibold))
                        WrappingHStack(responseData.allIngredients, id: \.self) { ingredient in
                            Text(ingredient)
                                .font(responseData.avoidIngredients.contains(where: { ingredient.contains($0) }) ? .system(size: 17, weight: .semibold) : .system(size: 17))
                                .foregroundColor(responseData.avoidIngredients.contains(where: { ingredient.contains($0) }) ? .deepOrange : .black)
                                .padding(.bottom, 2)
                        }
                    }
                }
                .padding(20)
            } else {
                LoadingView()
                    .padding(20)
            }
        }
    }
}

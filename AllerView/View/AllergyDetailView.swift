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

// MARK: - Views

extension AllergyDetailView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                // Background Color
                Color.blueGray
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        if let uiImage = gptModel.uiImage {
                            ProductImage(uiImage, proxy)
                        } else {
                            ProgressView()
                        }

                        DetailHeaderView()

                        ZStack {
                            SummaryBox()

                            if let responseData = gptModel.gptResponse {
                                DetailBodyView(responseData)
                            } else if gptModel.isFailed {
                                FailView()
                            } else {
                                LoadingView()
                                    .padding(20)
                            }
                        }
                        .padding(.bottom, 80)
                    }
                    .padding(.horizontal, 25)
                }
            }
        }
        .presentationDragIndicator(.visible)
    }

    private func DetailHeaderView() -> some View {
        HStack {
            Image("AIHead")
            Text("AI Summary")
                .foregroundColor(.defaultGray)
            Spacer()
        }
    }

    private func DetailBodyView(_ responseData: OpenAIChat.Content) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            if !responseData.warningAllergies.isEmpty {
                AttentionTo(responseData)

                if !responseData.unidentifiableIngredients.isEmpty {
                    Divider()
                    UnidentifiableIngredients(responseData)
                }
            }

            if responseData.warningAllergies.isEmpty {
                FreeOfAllergies()
            }

            Divider()
            AllIngredients(responseData)
        }
        .padding(20)
    }

    private func FailView() -> some View {
        HStack(alignment: .top) {
            Text("Fail to recognition\nPlease retake")
                .foregroundColor(.deepOrange)
                .font(.system(size: 25, weight: .semibold))
            Spacer()
            RefreshButton()
        }
        .padding(20)
    }
}

// MARK: - Componenets

private extension AllergyDetailView {
    @ViewBuilder
    private func ProductImage(_ uiImage: UIImage, _ proxy: GeometryProxy) -> some View {
        let croppedImage = ImageUtility.cropImageToSquare(for: uiImage, in: proxy)
        Image(uiImage: croppedImage!)
            .resizable()
            .scaledToFit()
            .frame(width: proxy.size.width)
            .padding(.horizontal, -25)
            .padding(.bottom, 12)
    }

    @ViewBuilder
    private func AttentionTo(_ responseData: OpenAIChat.Content) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 4) {
                Image(systemName: "exclamationmark.bubble")
                Text("Attention to")
                Spacer()
                RefreshButton()
            }
            .font(.system(size: 20, weight: .bold))

            WrappingHStack(responseData.warningAllergies, id: \.self) { warnAllergy in
                Chip(name: warnAllergy, height: 29, isRemovable: false, chipColor: .deepOrange, fontSize: 17, fontColor: .white)
                    .fontWeight(.medium)
                    .padding(.bottom, 6)
            }
        }
    }

    @ViewBuilder
    private func RefreshButton() -> some View {
        Button {
            gptModel.gptResponse = nil
            gptModel.isFailed = false
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
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .font(.system(size: 20, weight: .regular))
    }

    @ViewBuilder
    private func SummaryBox() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
    }

    @ViewBuilder
    private func AllIngredients(_ responseData: OpenAIChat.Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("All Ingredients")
                .font(.system(size: 17, weight: .semibold))
            WrappingHStack(responseData.allIngredients, id: \.self) { ingredient in
                Text(ingredient)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    .padding(.bottom, 2)
            }
        }
    }

    @ViewBuilder
    private func FreeOfAllergies() -> some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.seal.fill")
            Text("Free of allergies.")
                .font(.system(size: 17, weight: .medium))
            Spacer()
            RefreshButton()
        }
        .foregroundColor(.green)
    }

    @ViewBuilder
    private func UnidentifiableIngredients(_ responseData: OpenAIChat.Content) -> some View {
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
}

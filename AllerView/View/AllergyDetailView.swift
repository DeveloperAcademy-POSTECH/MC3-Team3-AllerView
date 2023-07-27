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

                            VStack(alignment: .leading) {
                                Text("There is ")
                                WrappingHStack(gptResult.warnIngredients, id: \.self) { warnIngredient in
                                    Chip(name: warnIngredient, height: 29, isRemovable: false, chipColor: .deepOrange, fontSize: 20, fontColor: .black)
                                }

                                Text("watch out for")
                                WrappingHStack(gptResult.warnAllergies, id: \.self) { warnAllergy in
                                    Chip(name: warnAllergy, height: 29, isRemovable: false, chipColor: .orange, fontSize: 20, fontColor: .white)
                                }

                                Divider()

                                Text("More Ingredient")
                                WrappingHStack(gptResult.allIngredients, id: \.self) { ingredient in
                                    Text(ingredient)
                                        .font(.customBody)
                                        .foregroundColor(gptResult.warnIngredients.contains(where: { $0 == ingredient }) ? .deepOrange : .black)
                                }
                            }
                            .font(.customHeadline)
                            .padding(20)
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
                // Re-Request ChapGPT
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

// MARK: - Previews

struct AllergyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AllergyDetailView(
            imageUrl: "https://hips.hearstapps.com/hmg-prod/images/cute-cat-photos-1593441022.jpg?crop=1.00xw:0.753xh;0,0.153xh&resize=1200:*",
            gptResult: GPTResult.sampleData
        )
    }
}

//
//  ProductDetailView.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/13.
//

import SwiftUI

// MARK: - Property

struct ProductDetailView {
    let recentData: RecentData
    let keywords: FetchedResults<Keyword>
}

// MARK: - View

extension ProductDetailView: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    AsyncImage(
                        url: URL(string: recentData.imageUrl),
                        content: { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width)
                                .background(.gray)
                        },
                        placeholder: { ProgressView() }
                    )

                    VStack(alignment: .leading) {
                        Text(recentData.name)
                            .font(.customTitle)
                            .padding(.bottom, 10)

                        Text("Allergen Ingredients")
                            .font(.customHeadline)
                        Divider()
                        ForEach(recentData.allergen + recentData.ingredients, id: \.self) { allergy in
                            if keywords.contains(where: { $0.name!.lowercased() == allergy.lowercased() }) {
                                Chip(name: allergy.lowercased(), height: 25, isRemovable: false, chipColor: Color.deepOrange, fontSize: 13, fontColor: Color.white)
                            }
                        }

                        Text("More Ingredient")
                            .font(.customHeadline)
                        Divider()
                        ForEach(recentData.allergen + recentData.ingredients, id: \.self) { ingredient in
                            Chip(name: ingredient.lowercased(), height: 25, isRemovable: false, chipColor: Color.blue, fontSize: 13, fontColor: Color.white)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.leading, 25)
                }
            }
        }
    }
}

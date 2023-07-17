//
//  DummyData.swift
//  AllerViewMain
//
//  Created by Hyemi on 2023/07/12.
//

import SwiftUI

//리스트 안의 각 아이템에 들어가는 데이터..
struct RecentData: Identifiable {
    var id = UUID()
    var itemImage: String
    var itemName: String
    var allergen: [String]
    var ingredients: [String]
    //  var ItemChip: ???
    
    static func recentsDummyData() -> [RecentData] {
        return [
            RecentData(
                itemImage: "LotteSand",
                itemName: "LotteSand",
                allergen: ["Wheat", "Milk", "Soybean"],
                ingredients: ["Wheat", "Vegetable Oil", "Dextrose", "Shortening", "Sugar", "Lactose", "Other processed products I", "Other glucose", "Refined Salt", "Acid regulator I", "Pineapple Juice Powder", "Mixed substances (Natural coloring agents, Synthetic flavorings, Triacetin, Propylene glycol, Essence)", "Lecithin", "Acid regulator II", "Vanillin", "Citric acid, DL-Apple acid", "Emulsifier", "Other processed products II"]
            ),
            RecentData(
                itemImage: "Haribo",
                itemName: "HARIBO Fruity-Bussi",
                allergen: ["Wheat", "Peach", "Pork"],
                ingredients: [
                    "Glucose syrup", "Sugar, Dextrose", "Gelatine (Pork)", "Citric acid", "Mango", "Orange", "Raspberry","Carrot", "Lemon", "Hibiscus", "Annatto coloring", "Spirulina", "coloring", "Carageenan", "Natural flavorings", "Artificial flavorings", "Beeswax", "Carnauba wax"]
            ),
            RecentData(
                itemImage: "Saewooggang",
                itemName: "SaeWooGGang",
                allergen: ["Wheat", "Shrimp", "Soybeans", "Milk"],
                ingredients: ["Wheat Flour", "Corn Starch", "Shrimp", "Palm Oil", "Shrimp Powder", "Shrimp Extract Powder", "Tapioca Modified Starch", "Maltodextrin", "Shrimp-Flavored Seasoning", "Salt and Seasonings"]),
           
        ]
    }
}


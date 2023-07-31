//
//  Product.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/18.
//

import Foundation

struct Product: Identifiable {
    let id = UUID()
    let imageUrl: String
    let barcode: String
    let name: String
    let allergen: [String]
    let ingredients: [String]
}

extension Product {
    static let sampleData: [Product] = [
        Product(
            imageUrl: "https://firebasestorage.googleapis.com/v0/b/steady-copilot-206205.appspot.com/o/goods%2F67f50b3a-d431-4552-230b-28bdcf032006%2F67f50b3a-d431-4552-230b-28bdcf032006_front_angle_1000_w.jpg?alt=media&token=e07e22b9-3035-4cc6-a253-2a34afb3ea1a",
            barcode: "8801062870509",
            name: "LotteSand",
            allergen: ["Wheat", "Milk", "Soybean"],
            ingredients: ["Vegetable Oil", "Dextrose", "Shortening", "Sugar", "Lactose", "Other processed products I", "Other glucose", "Refined Salt", "Acid regulator I", "Pineapple Juice Powder", "Mixed substances", "Lecithin", "Acid regulator II", "Vanillin", "Citric acid, DL-Apple acid", "Emulsifier", "Other processed products II"]
        ),
        Product(
            imageUrl: "https://firebasestorage.googleapis.com/v0/b/steady-copilot-206205.appspot.com/o/goods%2Fe47a72f6-2752-4519-25bf-0440d0cc8dc1%2Fe47a72f6-2752-4519-25bf-0440d0cc8dc1_front_angle_1000_w.jpg?alt=media&token=75380fe1-a5dd-40a4-aecf-c194946ffd6a",
            barcode: "4001686375754",
            name: "HARIBO Fruity-Bussi",
            allergen: ["Wheat", "Peach", "Pork"],
            ingredients: ["Glucose syrup", "Sugar, Dextrose", "Gelatine (Pork)", "Citric acid", "Mango", "Orange", "Raspberry", "Carrot", "Lemon", "Hibiscus", "Annatto coloring", "Spirulina", "coloring", "Carageenan", "Natural flavorings", "Artificial flavorings", "Beeswax", "Carnauba wax"]
        ),
        Product(
            imageUrl: "https://firebasestorage.googleapis.com/v0/b/steady-copilot-206205.appspot.com/o/goods%2Fe48c87ce-cc0c-4d88-9190-34c39f36a483%2Fe48c87ce-cc0c-4d88-9190-34c39f36a483_front_angle_1000_w.jpg?alt=media&token=bd99e593-e215-44f5-be8f-54d59522f172",
            barcode: "8801043035989",
            name: "SaeWooGGang",
            allergen: ["Wheat", "Shrimp", "Soybeans", "Milk"],
            ingredients: ["Wheat Flour", "Corn Starch", "Palm Oil", "Shrimp Powder", "Shrimp Extract Powder", "Tapioca Modified Starch", "Maltodextrin", "Shrimp-Flavored Seasoning", "Salt and Seasonings"]
        ),
    ]
}

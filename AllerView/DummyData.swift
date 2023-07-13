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
    var ItemImage: String
    var ItemName: String
    var chips: [ChipData]
    //  var ItemChip: ???
    
    static func recentsDummyData() -> [RecentData] {
        return [
            RecentData(ItemImage: "strawberry", ItemName: "Coke", chips: [
                ChipData(chipText: "Orange"),
                ChipData(chipText: "Grape"),
                ChipData(chipText: "Crap"),
                ChipData(chipText: "Chicken"),
            ]),
            RecentData(ItemImage: "apfel", ItemName: "Sprite", chips: [
//                ChipData(chipText: "none"),
            ]),
            RecentData(ItemImage: "octopus", ItemName: "Fanta", chips: [
                ChipData(chipText: "Crap"),
                ChipData(chipText: "Chicken"),
            ]),
            RecentData(ItemImage: "coke", ItemName: "Strawberry", chips: [
                ChipData(chipText: "Orange"),
                ChipData(chipText: "Crap"),
                ChipData(chipText: "Chicken"),
            ]),
        ]
    }
}

//칩에 들어가는 데이터..
struct ChipData: Identifiable, Hashable {
    var id = UUID().uuidString
    var chipText: String
    
    static func chipsDummyData() -> [ChipData] {
        return [
            ChipData(chipText: "none"),
            ChipData(chipText: "Orange"),
            ChipData(chipText: "Grape"),
            ChipData(chipText: "Crap"),
            ChipData(chipText: "Chicken"),
        ]
    }
}

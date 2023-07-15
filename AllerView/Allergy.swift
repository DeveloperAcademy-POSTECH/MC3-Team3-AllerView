// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let body: Body
    let header: Header
}

// MARK: - Body
struct Body: Codable {
    let items: [ItemElement]
    let totalCount, pageNo, numOfRows: String
}

// MARK: - ItemElement
struct ItemElement: Codable {
    let item: ItemItem
}

// MARK: - ItemItem
struct ItemItem: Codable {
    let nutrient, rawmtrl, prdlstNm: String
    let imgurl2: String
    let barcode: String
    let imgurl1: String
    let productGB, seller, prdkindstate, rnum: String
    let manufacture, prdkind, capacity, prdlstReportNo: String
    let allergy: String

    enum CodingKeys: String, CodingKey {
        case nutrient, rawmtrl, prdlstNm, imgurl2, barcode, imgurl1
        case productGB = "productGb"
        case seller, prdkindstate, rnum, manufacture, prdkind, capacity, prdlstReportNo, allergy
    }
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMessage: String
}

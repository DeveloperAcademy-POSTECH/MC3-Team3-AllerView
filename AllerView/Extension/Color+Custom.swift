//
//  Color+Custom.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/24.
//

import SwiftUI

public extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double((rgb >> 0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }

    static let deepOrange = Color(hex: "fdab00")
    static let defaultOrange = Color(hex: "ffba2d")
    static let deepYellow = Color(hex: "ffd12d")
    static let yellow = Color(hex: "ffde68")
    static let lightYellow = Color(hex: "fff1bf")

    static let green = Color(hex: "04b000")

    static let blueGray = Color(hex: "f2f4f6")

    static let black = Color(hex: "000000")
    static let deepGray1 = Color(hex: "323232")
    static let deepGray2 = Color(hex: "646464")
    static let defaultGray = Color(hex: "969696")
    static let lightGray1 = Color(hex: "C8C8C8")
    static let lightGray2 = Color(hex: "EBEBEB")
    static let White = Color(hex: "FFFFFF")
}

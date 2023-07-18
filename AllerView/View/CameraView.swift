//
//  CameraView.swift
//  AllerView
//
//  Created by Eojin Choi on 2023/07/13.
//

import CarBode
import SwiftUI

struct CameraView: View {
    // MARK: - Variables

    @Environment(\.presentationMode) var presentationMode
    @State private var isFlashOn = false
    @State private var isSheet = false
    @State private var searchedBarcode = ""

    // MARK: - DummyCheckArray For UserTest

    @Binding var check: [Bool]
    private let barcodes = ["8801062870509", "4001686375754", "8801043035989"]
    let keywords: FetchedResults<Keyword>

    var body: some View {
        ZStack {
            // MARK: - Barcode Scanner

            CBScanner(
                supportBarcode: .constant([.codabar, .code39, .code39Mod43, .code93, .code128, .ean8, .ean13, .gs1DataBar, .gs1DataBarLimited, .gs1DataBarExpanded, .interleaved2of5, .itf14, .upce]),
                torchLightIsOn: $isFlashOn,
                scanInterval: .constant(5)
            ) { barcode in
                if isSheet == true {
                    return
                }
                
                if let barcodeIndex = barcodes.firstIndex(of: barcode.value) {
                    check[barcodeIndex] = true
                    searchedBarcode = barcode.value
                    isSheet.toggle()
                }
            } onDraw: { barcodeView in
                // line width
                let lineWidth: CGFloat = 2

                // line color
                let lineColor = UIColor.red

                // Fill color with opacity
                // You also can use UIColor.clear if you don't want to draw fill color
                let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)

                barcodeView.draw(lineWidth: lineWidth, lineColor: lineColor, fillColor: fillColor)
            }

            // MARK: - Detecting Box

            // add something to here

            // MARK: - Flash Toggle Button

            VStack {
                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        isFlashOn.toggle()
                    }) {
                        Image(isFlashOn ? "icon_flash_on" : "icon_flash_off")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .padding(.trailing, 46)
                    .padding(.bottom, 85)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isSheet) {
            if let recentData = RecentData.recentsDummyData().first(where: { $0.barcode == searchedBarcode }) {
                ProductDetailView(recentData: recentData, keywords: keywords)
            }
        }
    }
}

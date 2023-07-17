//
//  CameraView.swift
//  AllerView
//
//  Created by Eojin Choi on 2023/07/13.
//

import SwiftUI
import CarBode

struct CameraView: View {
    
    // MARK: - Variables
    
    @State private var isFlashOn = false
    
    var body: some View {
        
        ZStack {
            // MARK: - Barcode Scanner
            
            CBScanner(
                supportBarcode: .constant([.codabar, .code39, .code39Mod43, .code93, .code128, .ean8, .ean13, .gs1DataBar, .gs1DataBarLimited, .gs1DataBarExpanded, .interleaved2of5, .itf14, .upce]),
                torchLightIsOn: $isFlashOn,
                scanInterval: .constant(5)
            ) { barcode in
                print("BarCodeType =", barcode.type.rawValue, "Value =", barcode.value)
            } onDraw: { barcodeView in
                print("Preview View Size =", barcodeView.cameraPreviewView.bounds)
                print("Barcode Corners =", barcodeView.corners)
                
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
        }.edgesIgnoringSafeArea(.all)
    }
}


struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

//
//  ImageCropView.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/07/26.
//
import SwiftUI

struct ImageCropView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var gptModel: GPTModel
    
    @State private var topLeft = CGSize(width: 100, height: 100)
    @State private var topRight = CGSize(width: 300, height: 100)
    @State private var bottomLeft = CGSize(width: 100, height: 300)
    @State private var bottomRight = CGSize(width: 300, height: 300)
    
    @State private var topLeftAccumulatedOffset = CGSize(width: 100, height: 100)
    @State private var topRightAccumulatedOffset = CGSize(width: 300, height: 100)
    @State private var bottomLeftAccumulatedOffset = CGSize(width: 100, height: 300)
    @State private var bottomRightAccumulatedOffset = CGSize(width: 300, height: 300)
    @State private var drag = CGSize.zero
    @State private var dragAccumulatedOffset = CGSize.zero
    @State private var croppedImage: UIImage? = nil
    @State private var boundingBoxes: [CGRect] = []
    
    // 전 뷰에서 넘어온 이미지가 들어올 곳
    @Binding var picData: Data
    @Binding var isSheetPresented: Bool
    
    let keywords: FetchedResults<Keyword>
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                if let originalImage = UIImage(data: picData) {
                    let image = ImageUtility.cropImageByViewRatio(for: originalImage, in: geometry)
                    
                    // MARK: Image Area
                    
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFill()
                        .overlay(
                            ForEach(0 ..< boundingBoxes.count, id: \.self) { index in
                                // draw bounding box
                                BoundingBoxOverlay(box: boundingBoxes[index])
                            }
                        )
                        .onAppear {
                            // MARK: for "원재료명" Highlight
                            
                            print("height: \(geometry.size.height)")
                            print("width: \(geometry.size.width)")
                            highlightingIngredients(image: image!)
                        }
                    
                    // MARK: Crop Box
                    
                    CropBox
                    
                    // MARK: Crop Points
                    
                    CropPoints
                    
                    VStack {
                        Spacer()
                        
                        ZStack {
                            // MARK: Bottom Rectangle Box
                            
                            RoundedRectangle(cornerRadius: 15)
                                .frame(height: 240)
                                .foregroundColor(.black)
                            
                            // MARK: Crop And OCR Function Call BTN
                            
                            VStack(spacing: 41) {
                                Text("Please crop the section\nof '원재료명(Ingredients)'")
                                    .font(Font.custom("SF Pro", size: 20).weight(.medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .frame(width: 340, alignment: .center)
                                HStack(spacing: 20) {
                                    Button {
                                        dismiss()
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(.white)
                                            Image(systemName: "arrow.clockwise")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20)
                                                .foregroundColor(.deepGray2)
                                        }
                                    }
                                    
                                    Button {
                                        let points = ImageUtility.convertToImageCoordinates(from: [
                                            CGPoint(
                                                x: drag.width + topLeft.width,
                                                y: drag.height + topLeft.height
                                            ),
                                            CGPoint(
                                                x: drag.width + topRight.width,
                                                y: drag.height + topRight.height
                                            ),
                                            CGPoint(
                                                x: drag.width + bottomRight.width,
                                                y: drag.height + bottomRight.height
                                            ),
                                            CGPoint(
                                                x: drag.width + bottomLeft.width,
                                                y: drag.height + bottomLeft.height
                                            ),
                                        ], for: image!, in: geometry)
                                        
                                        // MARK: Crop Image
                                        
                                        croppedImage = ImageUtility.cropImage(image!, points: points)
                                        
                                        // MARK: Vision OCR Call
                                        
                                        VisionUtility.recognizeText(in: croppedImage!) { recognizedStrings in
                                            let allergies = keywords.map { $0.name ?? "unknown" }.joined(separator: " ")
                                            let scannedData = recognizedStrings.joined(separator: " ")
                                            print(scannedData)
                                            gptModel.setSendProperties(allergies: allergies, scannedData: scannedData)
                                            gptModel.uiImage = image
                                            gptModel.sendMessage()
                                        }
                                        
                                        isSheetPresented = true
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            dismiss()
                                        }
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 30)
                                                .foregroundColor(.deepOrange)
                                            Text("Next")
                                                .font(Font.custom("SF Pro", size: 25).weight(.bold))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .frame(height: 60)
                            }
                            .padding(.horizontal, 25)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    var CropBox: some View {
        Rectangle()
            .fill(Color.blue.opacity(0.3))
            .overlay(Rectangle().stroke(Color.blue, lineWidth: 2))
            .frame(width: topRight.width - topLeft.width, height: bottomLeft.height - topLeft.height)
            .offset(x: drag.width + topLeft.width, y: drag.height + topLeft.height)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.drag = dragAccumulatedOffset + gesture.translation
                    }
                    .onEnded { gesture in
                        dragAccumulatedOffset = dragAccumulatedOffset + gesture.translation
                    }
            )
    }
    
    @ViewBuilder
    var CropPoints: some View {
        // Top left corner
        Circle()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
            .offset(
                x: drag.width + topLeft.width-10,
                y: drag.height + topLeft.height-10
            )
//            .overlay{
//                Circle()
//                    .frame(width: 60, height: 60)
//                    .offset(
//                        x: drag.width + topLeft.width-10,
//                        y: drag.height + topLeft.height-10
//                    )
//                    .foregroundColor(Color.black.opacity(0.000001))
//            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let newTopLeft = topLeftAccumulatedOffset + gesture.translation
                        
                        self.topLeft = newTopLeft
                        self.bottomLeft.width = newTopLeft.width
                        self.topRight.height = newTopLeft.height
                        
                    }
                    .onEnded { gesture in
                        topLeftAccumulatedOffset = topLeft
                        bottomLeftAccumulatedOffset.width = topLeft.width
                        topRightAccumulatedOffset.height = topLeft.height
                    }
            )
        
        // Top right corner
        Circle()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
            .offset(
                x: drag.width + topRight.width - 10,
                y: drag.height + topRight.height - 10
            )
//            .overlay{
//                Circle()
//                    .frame(width: 60, height: 60)
//                    .offset(
//                        x: drag.width + topRight.width - 10,
//                        y: drag.height + topRight.height - 10
//                    )
//                    .foregroundColor(Color.black.opacity(0.000001))
//            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let newTopRight = topRightAccumulatedOffset + gesture.translation
                        
                        self.topRight = newTopRight
                        self.bottomRight.width = newTopRight.width
                        self.topLeft.height = newTopRight.height
                        
                    }
                    .onEnded { gesture in
                        topRightAccumulatedOffset = topRight
                        bottomRightAccumulatedOffset.width = topRight.width
                        topLeftAccumulatedOffset.height = topRight.height
                    }
            )
        
        // Bottom left corner
        Circle()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
            .offset(
                x: drag.width + bottomLeft.width - 10,
                y: drag.height + bottomLeft.height - 10
            )
//            .overlay{
//                Circle()
//                    .frame(width: 60, height: 60)
//                    .offset(
//                        x: drag.width + bottomLeft.width - 10,
//                        y: drag.height + bottomLeft.height - 10
//                    )
//                    .foregroundColor(Color.black.opacity(0.000001))
//            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let newBottomLeft = bottomLeftAccumulatedOffset + gesture.translation
                        
                        self.bottomLeft = newBottomLeft
                        self.topLeft.width = newBottomLeft.width
                        self.bottomRight.height = newBottomLeft.height
                        
                    }
                    .onEnded { gesture in
                        bottomLeftAccumulatedOffset = bottomLeft
                        topLeftAccumulatedOffset.width = bottomLeft.width
                        bottomRightAccumulatedOffset.height = bottomLeft.height
                    }
            )
        
        // Bottom right corner
        
        Circle()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
            .offset(
                x: drag.width + bottomRight.width - 10,
                y: drag.height + bottomRight.height - 10
            )
        
//            .overlay{
//                Circle()
//                    .frame(width: 60, height: 60)
//                    .offset(
//                        x: drag.width + bottomRight.width - 10,
//                        y: drag.height + bottomRight.height - 10
//                    )
//                    .foregroundColor(Color.black.opacity(0.000001))
//            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let newBottomRight = bottomRightAccumulatedOffset + gesture.translation
                        
                        self.bottomRight = newBottomRight
                        self.topRight.width = newBottomRight.width
                        self.bottomLeft.height = newBottomRight.height
                        
                    }
                    .onEnded { gesture in
                        bottomRightAccumulatedOffset = bottomRight
                        topRightAccumulatedOffset.width = bottomRight.width
                        bottomLeftAccumulatedOffset.height = bottomRight.height
                    }
            )
    }
    
    func highlightingIngredients(image: UIImage) {
        VisionUtility.recognizeText(in: image) { recognizedText, boundingBox in
            for (index, element) in recognizedText.enumerated() {
                if element.contains("원재료명") {
                    // append bounding box
                    boundingBoxes.append(boundingBox[index])
                    break
                }
            }
            print("Init Recognized Text: \(recognizedText)")
        }
    }
}

struct BoundingBoxOverlay: View {
    var box: CGRect
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .path(in: CGRect(x: box.origin.x * geometry.size.width,
                                 y: (1 - box.origin.y - box.height) * geometry.size.height,
                                 width: box.width * geometry.size.width,
                                 height: box.height * geometry.size.height))
                .stroke(Color.deepOrange, lineWidth: 2)
        }
    }
}

//원재료명
// struct ImageCropView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageCropView()
//    }
// }

//
//  ImageCropView.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/07/26.
//
import SwiftUI

struct ImageCropView: View {
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

    var body: some View {
        ZStack {
            if let image = UIImage(data: picData) {
                GeometryReader { geometry in
                    if let croppedImage = croppedImage {
                        Image(uiImage: croppedImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        // MARK: Image Area

                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .overlay(
                                ForEach(0 ..< boundingBoxes.count, id: \.self) { index in
                                    // draw bounding box
                                    BoundingBoxOverlay(box: boundingBoxes[index])
                                }
                            )

                            // MARK: for "원재료명" Highlight

                            .onAppear {
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

                    // MARK: Crop Box

                    cropBox

                    // MARK: Crop Points

                    cropPoints

                    VStack {
                        Spacer()

                        ZStack {
                            // MARK: Bottom Rectangle Box

                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 390, height: 280)
                                .background(.black.opacity(0.7))
                                .cornerRadius(15)

                            // MARK: Crop And OCR Function Call BTN

                            VStack(spacing: 26) {
                                Text("Please crop the section\nof '원재료명(Ingredients)'")
                                    .font(Font.custom("SF Pro", size: 20).weight(.medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .frame(width: 340.00012, height: 75, alignment: .center)
                                Button(action: {
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
                                    ], for: image, in: geometry)

                                    // MARK: Crop Image

                                    croppedImage = ImageUtility.cropImage(image, points: points)

                                    // MARK: Vision OCR Call

                                    VisionUtility.recognizeText(in: croppedImage!) { recognizedStrings in
                                        print(recognizedStrings)
                                    }

                                }) {
                                    Text("Next")
                                        .font(Font.custom("SF Pro", size: 25).weight(.bold))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.99, green: 0.67, blue: 0))
                                }
                                .padding(.horizontal, 143)
                                .padding(.vertical, 25)
                                .frame(width: 340, alignment: .center)
                                .background(.white)
                                .cornerRadius(15)
                            }
                        }
                    }
                    .ignoresSafeArea(.all, edges: .all)
                }
            } else {
                ProgressView()
            }
        }
    }

    @ViewBuilder
    var cropBox: some View {
        let path = Path { path in
            path.move(to: CGPoint(
                x: drag.width + topLeft.width,
                y: drag.height + topLeft.height
            ))
            path.addLine(to: CGPoint(
                x: drag.width + topRight.width,
                y: drag.height + topRight.height
            ))
            path.addLine(to: CGPoint(
                x: drag.width + bottomRight.width,
                y: drag.height + bottomRight.height
            ))
            path.addLine(to: CGPoint(
                x: drag.width + bottomLeft.width,
                y: drag.height + bottomLeft.height
            ))
            path.closeSubpath()
        }
        path
            .fill(Color.blue)
            .opacity(0.3)
            .overlay(path.stroke(Color.blue, lineWidth: 2))
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
    var cropPoints: some View {
        Circle()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
            .offset(
                x: drag.width + topLeft.width - 10,
                y: drag.height + topLeft.height - 10
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.topLeft = topLeftAccumulatedOffset + gesture.translation
                    }
                    .onEnded { gesture in
                        topLeftAccumulatedOffset = topLeftAccumulatedOffset + gesture.translation
                    }
            )
        Circle()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
            .offset(
                x: drag.width + topRight.width - 10,
                y: drag.height + topRight.height - 10
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.topRight = topRightAccumulatedOffset + gesture.translation
                    }
                    .onEnded { gesture in
                        topRightAccumulatedOffset = topRightAccumulatedOffset + gesture.translation
                    }
            )
        Circle()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
            .offset(
                x: drag.width + bottomLeft.width - 10,
                y: drag.height + bottomLeft.height - 10
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.bottomLeft = bottomLeftAccumulatedOffset + gesture.translation
                    }
                    .onEnded { gesture in
                        bottomLeftAccumulatedOffset = bottomLeftAccumulatedOffset + gesture.translation
                    }
            )
        Circle()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
            .offset(
                x: drag.width + bottomRight.width - 10,
                y: drag.height + bottomRight.height - 10
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.bottomRight = bottomRightAccumulatedOffset + gesture.translation
                    }
                    .onEnded { gesture in
                        bottomRightAccumulatedOffset = bottomRightAccumulatedOffset + gesture.translation
                    }
            )
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
                .stroke(Color.red, lineWidth: 2)
        }
    }
}

//
// struct ImageCropView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageCropView()
//    }
// }

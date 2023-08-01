//
//  ScannerView.swift
//  AllerView
//
//  Created by Eojin Choi on 2023/07/24.
//

import AVFoundation
import SwiftUI
import Vision

struct ScannerView: View {
    @StateObject private var camera = CameraViewModel()
    @ObservedObject var gptModel: GPTModel

    @Binding var isSheetPresented: Bool

    let keywords: FetchedResults<Keyword>

    var body: some View {
        ZStack {
            // MARK: Camera Previews

            CameraPreview(camera: camera)
                .ignoresSafeArea()

            // MARK: My Allergy Text

            VStack {
                HStack {
                    Spacer()

                    Button {
                        //
                    } label: {
                        Image("my_allergy_btn")
                    }
                }
                .padding(.horizontal, 25)

                Spacer()
            }
            .padding(.vertical, 16)

            // MARK: Control Area

            VStack {
                Spacer()

                ZStack {
                    // MARK: Bottom Rentangle Box

                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 280)
                        .background(.black.opacity(0.7))
                        .cornerRadius(15)

                    VStack(spacing: 30) {
                        Text("Please take a photo of the section\nlabeled '**원재료명**(Ingredients)'")
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 340, alignment: .center)

                        ZStack {
                            NavigationLink {
                                ImageCropView(gptModel: gptModel, picData: $camera.picData, isSheetPresented: $isSheetPresented, keywords: keywords)
                                    .navigationBarHidden(true)
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 82, height: 82)

                                    Circle()
                                        .stroke(.black, lineWidth: 3)
                                        .frame(width: 70, height: 70)
                                }
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                camera.takePic()
                            })

                            HStack {
                                Spacer()

                                Button {
                                    camera.isFlash.toggle()
                                    camera.toggleTorch(on: camera.isFlash)
                                } label: {
                                    if camera.isFlash {
                                        Image("icon_flash_on")
                                    } else {
                                        Image("icon_flash_off")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 22)
                    .padding(.horizontal, 25)
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            camera.check()
            camera.reTake()
        }
    }
}

extension ScannerView {
    struct CameraPreview: UIViewRepresentable {
        @ObservedObject var camera: CameraViewModel

        func makeUIView(context _: Context) -> some UIView {
            let view = UIView(frame: UIScreen.main.bounds)

            DispatchQueue.main.async {
                camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
                camera.preview.frame = view.frame

                camera.preview.videoGravity = .resizeAspectFill
                view.layer.addSublayer(camera.preview)
            }
            Task.detached(priority: .background) {
                await camera.session.startRunning()
            }

            return view
        }

        func updateUIView(_: UIViewType, context _: Context) {}
    }
}

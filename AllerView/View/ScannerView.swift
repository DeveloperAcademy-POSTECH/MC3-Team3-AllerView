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
    @ObservedObject var gptModel: GPTViewModel

    @Binding var isSheetPresented: Bool

    let keywords: FetchedResults<Keyword>
    
    @State private var picData: UIImage?
    @State var isFlash: Bool = false
    
    var scannerViewController = ScannerViewController()
    
    let hapticManager = HapticUtility.instance

    var body: some View {
        ZStack {
            // MARK: Camera Previews
            scannerViewController
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                // MARK: Control Area
                
                ZStack {
                    
                    // MARK: Bottom Rentangle Box
                    
                    Rectangle()
                        .frame(height: 280)
                        .background(Color.black)
                        .cornerRadius(15)
                    
                    VStack(spacing: 30) {
                        
                        Text("Please take a photo of the section\nlabeled '**원재료명**(Ingredients)'")
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 340, alignment: .center)
                        
                        ZStack {
                            
                            NavigationLink {
                                ImageCropView(gptModel: gptModel, picData: $picData, isSheetPresented: $isSheetPresented, keywords: keywords)
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
                                hapticManager.impact(style: .light)
                                
//                                camera.takePic()
                                Task {
                                    do {
                                        picData = try await scannerViewController.scannerViewController.capturePhoto()
                                    } catch {
                                        // Handle the error if needed
                                        print("Error capturing photo: \(error)")
                                    }
                                    scannerViewController.scannerViewController.stopScanning()
                                }
                            })
                            
                            HStack {
                                
                                Spacer()
                                
                                Button {
                                    isFlash.toggle()
                                    scannerViewController.toggleTorch(on: isFlash)
                                    hapticManager.impact(style: .light)
                                } label: {
                                    if isFlash {
                                        Image("icon_flash_on")
                                    } else {
                                        Image("icon_flash_off")
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 280)
                    .padding(.horizontal, 25)
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            try? scannerViewController.scannerViewController.startScanning()
        }
    }
}

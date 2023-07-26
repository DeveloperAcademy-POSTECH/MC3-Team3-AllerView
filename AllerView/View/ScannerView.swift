//
//  ScannerView.swift
//  AllerView
//
//  Created by Eojin Choi on 2023/07/24.
//

import SwiftUI
import AVFoundation

struct ScannerView: View {
    @StateObject var camera = CameraModel()

    var body: some View {
        ZStack {
            // MARK: Camera Previews
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
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
                        .frame(width: 390, height: 280)
                        .background(.black.opacity(0.7))
                        .cornerRadius(15)
                    
                    // MARK: Buttons and Description
                    VStack(spacing: 26) {
                        ZStack {
                            Button(action: {}, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 82, height: 82)
                                    
                                    Circle()
                                        .stroke(.black, lineWidth: 3)
                                        .frame(width: 70, height: 70)
                                }
                            })
                            
                            HStack {
                                Spacer()
                                
                                if camera.isFlash {
                                    Button(action: {
                                        camera.isFlash.toggle()
                                        camera.toggleTorch(on: camera.isFlash)
                                    }, label: {
                                        Image("icon_flash_on")
                                    })
                                } else {
                                    Button(action: {
                                        camera.isFlash.toggle()
                                        camera.toggleTorch(on: camera.isFlash)
                                    }, label: {
                                        Image("icon_flash_off")
                                    })
                                }
                            }
                            .padding(.horizontal, 25)
                        }
                        
                        Text("Please take a photo of the section labeled '원재료명(Ingredients)'")
                            .font(
                                Font.custom("SF Pro", size: 20)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 340.00012, height: 75, alignment: .center)
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .all)
        }
        .onAppear(perform: {
            camera.Check()
        })
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}

// MARK: - Camera Model

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken: Bool = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert: Bool = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview = AVCaptureVideoPreviewLayer()
    
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    @Published var isFlash: Bool = false
    
    func Check() {
        
        // first check cameras got permission
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            
            // setting up session
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {(status) in
                if status {
                    self.setUp()
                }
            })
        case .denied:
            self.alert.toggle()
            return
            
        default:
            break
        }
    }
    
    func setUp() {
        // setting up camera...
        
        do {
            // setting configurations...
            
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(for: .video)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            // checking and adding to session...
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            // same for output...
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }

    
    func takePic() {
        
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                self.isSaved = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if error != nil {
            return
        }
        
        print("pic taken...")
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        self.picData = imageData
    }
    
    func savePic() {
        let image = UIImage(data: self.picData)!
        
        // saving image...
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.isSaved = true
        print("saved successfully...")
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                device.torchMode = on ? .on : .off

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}

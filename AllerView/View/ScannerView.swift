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
    @StateObject var camera = CameraModel()

    var body: some View {
        ZStack {
            // MARK: Camera Previews

            CameraPreview(camera: camera)
                .ignoresSafeArea(.all)
//                .overlay(
//                    ForEach(camera.recognizedTexts) { recognizedText in
//                        BoundingBoxOverlay(box: recognizedText.boundingBox)
//                    }
//                )

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

                    if camera.isTaken {
                        VStack(spacing: 26) {
                            Text("Please crop the section\nof ‘원재료명(Ingredients)’")
                                .font(
                                    Font.custom("SF Pro", size: 20)
                                        .weight(.medium)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 340.00012, height: 75, alignment: .center)

                            HStack {
                                Button(action: camera.reTake, label: {
                                    Text("Cancel")
                                })

                                Button(action: {}, label: {
                                    Text("Next")
                                })
                            }
                        }
                    } else {
                        VStack(spacing: 26) {
                            ZStack {
                                Button(action: camera.takePic, label: {
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

                            Text("Please take a photo of the section\nlabeled '원재료명(Ingredients)'")
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
            }
            .ignoresSafeArea(.all, edges: .all)
        }
        .onAppear(perform: {
            camera.Check()
        })
    }
}

// MARK: - Camera Model

struct RecognizedText: Identifiable {
    let id = UUID()
    let text: String
    let boundingBox: CGRect
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

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var isTaken: Bool = false

    @Published var session = AVCaptureSession()

    @Published var alert: Bool = false

    @Published var output = AVCapturePhotoOutput()
    @Published var videoOutput = AVCaptureVideoDataOutput()
    @Published var recognizedTexts: [RecognizedText] = []

    @Published var preview = AVCaptureVideoPreviewLayer()

    @Published var isSaved = false
    @Published var picData = Data(count: 0)

    @Published var isFlash: Bool = false

    func Check() {
        // check camera permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return

        // setting up session
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { status in
                if status {
                    self.setUp()
                }
            })
        case .denied:
            alert.toggle()
            return

        default:
            break
        }
    }

    func setUp() {
        // setting up camera...

        do {
            session.beginConfiguration()

            session.sessionPreset = .photo

            let device = AVCaptureDevice.default(for: .video)
            let input = try AVCaptureDeviceInput(device: device!)

            if session.canAddInput(input) {
                session.addInput(input)
            }

            output = AVCapturePhotoOutput()
            if session.canAddOutput(output) {
                session.addOutput(output)
            }

            videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
            }

            session.commitConfiguration()

        } catch {
            print(error.localizedDescription)
        }
    }

    func takePic() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()

            DispatchQueue.main.async {
                withAnimation { self.isTaken.toggle() }
            }
        }
    }

    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()

            DispatchQueue.main.async {
                withAnimation { self.isTaken.toggle() }
                self.isSaved = false
            }
        }
    }

    func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }

        guard let imageData = photo.fileDataRepresentation() else { return }
        picData = imageData
    }

    func captureOutput(_: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from _: AVCaptureConnection) {
        // Sample buffer에서 이미지 처리 및 텍스트 인식 작업 수행
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .down)
        let request = VNRecognizeTextRequest(completionHandler: textDetectHandler)

        request.recognitionLanguages = ["ko"]
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request: \(error).")
        }
    }

    func textDetectHandler(request: VNRequest, error _: Error?) {
        // 텍스트 인식 결과 처리
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

        DispatchQueue.main.async {
            self.recognizedTexts.removeAll()

            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }

                if topCandidate.string.contains("원재료명") {
                    let boundingBox = observation.boundingBox

                    // UIKit에서 SwiftUI로 좌표계 변환
                    self.recognizedTexts.append(RecognizedText(text: topCandidate.string, boundingBox: boundingBox))
                }
            }
        }
    }

    func savePic() {
        let image = UIImage(data: picData)!

        // saving image...
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        isSaved = true
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
    var isFirst = true

    func makeUIView(context _: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)

        if isFirst {
            DispatchQueue.main.async {
                camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
                camera.preview.frame = view.frame

                camera.preview.videoGravity = .resizeAspectFill
                view.layer.addSublayer(camera.preview)
            }
            Task.detached(priority: .background) {
                await camera.session.startRunning()
            }
        }
        return view
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}

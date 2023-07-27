// MARK: - Camera Model

import AVFoundation
import SwiftUI

extension ScannerView {
    struct RecognizedText: Identifiable {
        let id = UUID()
        let text: String
        let boundingBox: CGRect
    }

    class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
        @Published var session = AVCaptureSession()

        @Published var alert: Bool = false

        @Published var output = AVCapturePhotoOutput()
        @Published var videoOutput = AVCaptureVideoDataOutput()
        @Published var recognizedTexts: [RecognizedText] = []

        @Published var preview = AVCaptureVideoPreviewLayer()

        @Published var isSaved = false
        @Published var picData = Data(count: 0)
        @Published var isCaptureComplete = false

        @Published var isFlash: Bool = false

        var isFirst = true

        func check() {
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
            if isFirst {
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
                isFirst.toggle()
            }
        }

        func takePic() {
            print("takePic() start")
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
//            self.session.stopRunning()
            print("takePic() end")
        }

        func reTake() {
            DispatchQueue.global(qos: .background).async {
                if !self.isFirst {
                    self.session.startRunning()
                }

                DispatchQueue.main.async {
                    self.picData = Data()
                    self.isSaved = false
                }
            }
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            print("photoOutput() delegate start")
            
            if let error = error {
                print("Error capturing photo: \(error.localizedDescription)")
                return
            }
            
            if let imageData = photo.fileDataRepresentation() {
                picData = imageData
                print("photoOutput() delegate end")
            }
//            guard let imageData = photo.fileDataRepresentation() else { return }
            
            // 촬영 완료 시점에 상태 업데이트
            DispatchQueue.main.async {
                self.isCaptureComplete = true
            }
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
}

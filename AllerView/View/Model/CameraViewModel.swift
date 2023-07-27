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
            DispatchQueue.main.async {
                self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
                self.session.stopRunning()
            }
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

        func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if error != nil {
                return
            }

            guard let imageData = photo.fileDataRepresentation() else { return }
            picData = imageData
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
}

//
//  MainView.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/07/25.
//

import SwiftUI
import AVFoundation
import Vision

struct MainView: View {
    var body: some View {
        CameraView()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct CameraView: UIViewControllerRepresentable {
    let cameraController = CameraViewController()
    func makeUIViewController(context: Context) -> CameraViewController {
        return cameraController
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
    }
    func getCameraController() -> CameraViewController{
        return cameraController
    }
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private var cameraFeedSession: AVCaptureSession?
    private var cameraFeedView: CameraFeedView!
    private var overlayLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try setupAVSession()
        } catch {
            print("setup av session failed")
        }
        overlayLayer.frame = view.bounds
        view.layer.addSublayer(overlayLayer)
    }
    
    func setupAVSession() throws {
        let wideAngle = AVCaptureDevice.DeviceType.builtInWideAngleCamera
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [wideAngle], mediaType: .video, position: .back)
        
        guard let videoDevice = discoverySession.devices.first else {
            print("Could not find a wide angle camera device.")
            return
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Could not create video device input.")
            return
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        if videoDevice.supportsSessionPreset(.hd1920x1080) {
            session.sessionPreset = .hd1920x1080
        } else {
            session.sessionPreset = .high
        }
        
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            return
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [
                String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            ]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            return
        }
        let captureConnection = dataOutput.connection(with: .video)
        captureConnection?.preferredVideoStabilizationMode = .standard
        captureConnection?.videoOrientation = .portrait
        captureConnection?.isEnabled = true
        session.commitConfiguration()
        cameraFeedSession = session
        
        let videoOrientation: AVCaptureVideoOrientation
        switch view.window?.windowScene?.interfaceOrientation {
        case .landscapeRight:
            videoOrientation = .landscapeRight
        default:
            videoOrientation = .portrait
        }
        
        cameraFeedView = CameraFeedView(frame: view.bounds, session: session, videoOrientation: videoOrientation)
        cameraFeedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                view.addSubview(cameraFeedView)
        cameraFeedSession?.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .down)
        let request = VNRecognizeTextRequest(completionHandler: textDetectHandler)
        request.recognitionLanguages = ["ko"]
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request: \(error).")
        }
    }
    
    func textDetectHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        DispatchQueue.main.async {
            self.overlayLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                if topCandidate.string.contains("원재료명") {
                    let boundingBox = observation.boundingBox
                    let outline = CALayer()
                    let padding: CGFloat = 10.0 // padding value
                    outline.frame = CGRect(x: (boundingBox.origin.x * self.view.bounds.width) - padding,
                                           y: (boundingBox.origin.y * self.view.bounds.height) - padding,
                                           width: (boundingBox.width * self.view.bounds.width) + 2 * padding,
                                           height: (boundingBox.height * self.view.bounds.height) + 2 * padding)
                    outline.borderWidth = 2.0
                    outline.borderColor = UIColor.red.cgColor
                    outline.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 0.5).cgColor // pastel blue color with transparency
                    self.overlayLayer.addSublayer(outline)
                }
            }
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

class CameraFeedView: UIView {
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    init(frame: CGRect, session: AVCaptureSession, videoOrientation: AVCaptureVideoOrientation) {
        super.init(frame: frame)
        previewLayer = layer as? AVCaptureVideoPreviewLayer
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = videoOrientation
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

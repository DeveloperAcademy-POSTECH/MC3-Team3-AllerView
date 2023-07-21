import SwiftUI
import AVFoundation

struct CustomCameraView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> CustomCameraViewController {
        return CustomCameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: CustomCameraViewController, context: Context) {
    }
    
    typealias UIViewControllerType = CustomCameraViewController
}

class CustomCameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupShutterButton()
    }
    
    func setupCamera() {
        let captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
        } catch {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            captureSession.startRunning()

            DispatchQueue.main.async { [weak self] in
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.frame = self?.view.layer.bounds ?? CGRect.zero
                self?.view.layer.addSublayer(previewLayer)
            }
        }
    }
}

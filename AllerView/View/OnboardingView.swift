//
//  OnboardingView.swift
//  AllerView
//
//  Created by 관식 on 2023/08/12.
//

import AVFoundation
import SwiftUI

struct OnboardingView: View {
    @Binding var cameraPermissionGranted: Bool
    
    var cameraAuthorizationStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Image("OnboardingIllust")
            VStack(spacing: 16) {
                Text("Access Your Camera")
                    .font(.system(size: 25, weight: .semibold))
                Text("Permission is required to access the camera to scan the product image.")
                    .font(.system(size: 17))
                    .foregroundColor(.defaultGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 25)
            }
            Spacer()
            Button {
                if cameraAuthorizationStatus == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        DispatchQueue.main.async {
                            cameraPermissionGranted = granted
                        }
                    }
                } else if cameraAuthorizationStatus == .denied || cameraAuthorizationStatus == .restricted {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            } label: {
                ZStack {
                    Capsule()
                        .frame(height: 56)
                        .foregroundColor(.deepOrange)
                    Text("Enable Access")
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 25)
            }
        }
        .onAppear {
            if cameraAuthorizationStatus == .authorized {
                cameraPermissionGranted = true
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

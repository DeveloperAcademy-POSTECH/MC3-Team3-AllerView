//
//  OnboardingView.swift
//  AllerView
//
//  Created by 관식 on 2023/08/12.
//

import SwiftUI

struct OnboardingView: View {
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
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

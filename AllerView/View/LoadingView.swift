//
//  LoadingView.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/31.
//

import Lottie
import SwiftUI

// MARK: - Properties

struct LoadingView {}

// MARK: - Views

extension LoadingView: View {
    var body: some View {
        LottieView(loopMode: .loop)
    }
}

// MARK: - Models

extension LoadingView {
    struct LottieView: UIViewRepresentable {
        let loopMode: LottieLoopMode

        func updateUIView(_: UIViewType, context _: Context) {}

        func makeUIView(context _: Context) -> some UIView {
            let animationView = LottieAnimationView(name: "Loading")
            animationView.play()
            animationView.loopMode = loopMode
            animationView.contentMode = .scaleAspectFit
            return animationView
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

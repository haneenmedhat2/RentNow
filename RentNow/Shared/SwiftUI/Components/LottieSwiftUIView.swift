//
//  LottieSwiftUIView.swift
//  HoloolProvider
//
//  Created by Elshamy on 05/01/2026.
//

import SwiftUI
import Lottie

struct LottieSwiftUIView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode

    init(animationName: String, loopMode: LottieLoopMode = .playOnce) {
        self.animationName = animationName
        self.loopMode = loopMode
    }

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)
        let animationView = Lottie.LottieAnimationView()

        guard let file = Bundle.main.path(forResource: animationName, ofType: "json") else {
            return containerView
        }

        animationView.animation = LottieAnimation.filepath(file)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed
    }
}

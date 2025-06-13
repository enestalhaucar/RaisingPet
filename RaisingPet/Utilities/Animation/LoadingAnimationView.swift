//
//  LoadingAnimationView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.02.2025.
//

import SwiftUI
import Lottie

struct LoadingAnimationView: View {
    var fileName: String = "LoadingAnimation"

    var body: some View {
        LottieView(animation: .named(fileName))
            .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .loop)))
            .frame(width: 100, height: 100)
    }
}

#Preview {
    LoadingAnimationView()
}

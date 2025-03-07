//
//  OnboardingView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 31.01.2025.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    OnBoardingViewOne()
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}

struct OnBoardingViewOne: View {
    var body: some View {
        VStack(spacing: 40) {
            Image("onboardingViewOnePhoto")
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
            
            VStack(alignment: .center, spacing: 20) {
                Text("Welcome to Petiverse")
                    .font(.nunito(.medium, .title320))
                
                Text("Bring your screen to life with lovable companions and unique widgets.")
                    .font(.nunito(.medium, .body16))
                    .multilineTextAlignment(.center)
            }.padding(.horizontal, 25)
        }
    }
}

//
//  OnboardingView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 31.01.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    var onOnboardingComplete: () -> Void
    
    let pages = [
        (image: "onboardingFirstImage", title: "onboarding_first_title".localized(), subtitle: "onboarding_first_subtitle".localized()),
        (image: "onboardingSecondImage", title: "onboarding_second_title".localized(), subtitle: "onboarding_second_subtitle".localized()),
        (image: "onboardingThirdImage", title: "onboarding_third_title".localized(), subtitle: "onboarding_third_subtitle".localized())
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(
                        imageName: pages[index].image,
                        title: pages[index].title,
                        subtitle: pages[index].subtitle
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            Button(action: {
                if currentPage < pages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    onOnboardingComplete() // Onboarding bitti
                }
            }) {
                Text(currentPage == pages.count - 1 ? "start_button".localized() : "continue_button".localized())
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    OnboardingView(onOnboardingComplete: {})
}

// Her bir sayfa için reusable view
struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            
            Text(title)
                .font(.nunito(.bold, .title222))
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.nunito(.medium, .headline17))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 50)
    }
}


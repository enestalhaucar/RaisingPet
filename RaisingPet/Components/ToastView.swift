//
//  ToastView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 22.07.2024.
//

import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Spacer() // Toast'u aşağıya iter
            if isShowing {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(message)
                }
                .font(.nunito(.semiBold, .body16))
                .foregroundColor(.primary)
                .padding()
                .background(.thinMaterial) // Modern, yarı saydam bir arkaplan
                .clipShape(Capsule())
                .shadow(radius: 10)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    // Toast göründükten 2 saniye sonra kaybolur
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.bottom, 30) // TabBar'ın üzerine gelmesi için biraz boşluk
        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0), value: isShowing)
        .allowsHitTesting(false) // Toast'un arkasındaki butonlara dokunulabilsin
    }
} 
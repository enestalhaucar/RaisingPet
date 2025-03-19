//
//  ContentView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    var onSplashComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Image("logoPetiverse")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isActive = true
                    onSplashComplete()
                }
            }
        }
    }
}

#Preview {
    SplashScreenView(onSplashComplete: {})
}

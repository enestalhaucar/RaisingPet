//
//  ContentView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI

struct SplashView: View {
    @Binding var isSuccess : Bool
    var body: some View {
        NavigationStack {
            ZStack {
                
                SignInUpBackground()
                
                VStack(spacing: 45) {
                    Spacer()
                    Image("splashViewPhoto")
                    Text("Get your Pet with PetApps")
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vulputate volutpat cursus euismod nunc sapien. Dictum id hac feugiat laoreet.")
                        .multilineTextAlignment(.center)
                    
                    NavigationLink {
                        SignUpView()
                    } label: {
                        // Components/Button
                        button(title: "Get Started")
                    }

                    
                    Spacer()
                    
                }.padding(.horizontal)
            }
        }
    }
}

#Preview {
    SplashView(isSuccess: .constant(false))
}

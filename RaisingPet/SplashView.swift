//
//  ContentView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor").ignoresSafeArea()
                
                Image("shapeEclipse")
                    .offset(x: -UIScreen.main.bounds.width / 2 + 70, y: -UIScreen.main.bounds.height / 2 + 50)
                
                VStack(spacing: 45) {
                    Spacer()
                    Image("splashViewPhoto")
                    Text("Get your Pet with PetApps")
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vulputate volutpat cursus euismod nunc sapien. Dictum id hac feugiat laoreet.")
                        .multilineTextAlignment(.center)
                    
                    NavigationLink {
                        
                    } label: {
                        button(title: "Get Started")
                    }

                    
                    Spacer()
                    
                }.padding(.horizontal)
            }
        }
    }
}

#Preview {
    SplashView()
}

//
//  RootView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 30.07.2024.
//

import SwiftUI

struct RootView: View {
    @State private var isSuccess : Bool = false
    var body: some View {
        ZStack {
            SignInUpBackground()
            if !isSuccess {
                VStack {
                    TabView {
                        Group {
                            HomeView()
                                .tabItem {
                                    VStack {
                                        Image(systemName: "house")
                                        Text("Home")
                                    }
                                }
                            
                            EmotionsView()
                                .tabItem {
                                    VStack {
                                        Image(systemName: "hands.and.sparkles")
                                        Text("Emotions")
                                    }
                                }
                            CoupleQuestionView()
                                .tabItem {
                                    VStack {
                                        Image(systemName: "person.fill.questionmark")
                                        Text("Couple Questions")
                                    }
                                }
                            
                            
                            ProfileView(isSuccess: $isSuccess)
                                .tabItem {
                                    VStack {
                                        Image(systemName: "person")
                                        Text("Profile")
                                    }
                                }
                        }
                        .toolbarBackground(.gray.opacity(0.1), for: .tabBar)
                            .toolbarBackground(.visible, for: .tabBar)
                    }
                }
            }
           
            
            
        }
                .fullScreenCover(isPresented: $isSuccess, content: {
            SplashView(isSuccess: $isSuccess)
        })
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            print(authUser ?? "auth boş")
           
            if authUser == nil {
                self.isSuccess = true
            }
            print("RootView on appear |\(isSuccess)")
            
        }
        
        
    }
}

#Preview {
    RootView()
}

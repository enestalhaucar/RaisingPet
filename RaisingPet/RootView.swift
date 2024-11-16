//
//  RootView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 30.07.2024.
//

import SwiftUI

struct RootView: View {
    
  
    @StateObject private var appViewModel = AppViewModel()
    var body: some View {
        ZStack {
            SignInUpBackground()
            if appViewModel.isLoggedIn {
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
                            
                            
                            ProfileView(appViewModel: appViewModel)
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
            } else {
                LoginView(appViewModel: appViewModel)
            }
            
        }.onAppear {
            appViewModel.checkIfLoggedIn()
        }
        
        
        
    }
}

#Preview {
    RootView()
}

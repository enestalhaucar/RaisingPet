//
//  RootView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 30.07.2024.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var appState: AppState
    var body: some View {
        ZStack {
            SignInUpBackground()
            if appState.isLoggedIn {
                VStack {
                    TabView {
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
                                    Image(
                                        systemName: "person.fill.questionmark"
                                    )
                                    Text("Couple Questions")
                                }
                            }
                        ProfileView(onLogout: handleLogout)
                            .tabItem {
                                VStack {
                                    Image(systemName: "person")
                                    Text("Profile")
                                }
                            }
                    }.toolbarBackground(.gray.opacity(0.1), for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                }
            } else {
                NavigationStack {
                    LoginView(onLoginSuccess: handleLoginSuccess)
                        .navigationDestination(for: String.self) { destination in
                            if destination == "SignUpView" {
                                SignUpView(onRegisterSuccess: handleLoginSuccess)
                            }
                        }
                }
            }
            
        }
        
        
    }
    
    
    
    private func handleLoginSuccess() {
           appState.isLoggedIn = true
       }

       private func handleLogout() {
           appState.isLoggedIn = false
       }
}

#Preview {
    RootView()
}

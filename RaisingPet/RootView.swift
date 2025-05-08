//
//  RootView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 30.07.2024.
//


import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSplash = true
    @State private var showOnboarding = false
    
    // Test için manuel kontrol
    private let isTesting = true // Test ederken true yap, production'da false olacak
    
    var body: some View {
        ZStack {
            SignInUpBackground()
            
            if showSplash {
                SplashScreenView(onSplashComplete: {
                    showSplash = false
                    // İlk açılışta onboarding gösterilecek mi kontrol et
                    let hasSeenOnboarding = UserDefaults.hasSeenOnboarding
                    if isTesting || !hasSeenOnboarding {
                        showOnboarding = true
                    }
                })
            } else if showOnboarding {
                OnboardingView(onOnboardingComplete: {
                    showOnboarding = false
                    UserDefaults.hasSeenOnboarding = true // Onboarding tamamlandı
                })
            } else if appState.isLoggedIn {
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
                                    Image(systemName: "person.fill.questionmark")
                                    Text("Couple Questions")
                                }
                            }
                        ProfileView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "person")
                                    Text("Profile")
                                }
                            }
                            .environmentObject(appState)
                    }
                    .toolbarBackground(.gray.opacity(0.1), for: .tabBar)
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
        .environmentObject(AppState()) // Preview için AppState ekle
}

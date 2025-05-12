//
//  RootView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 30.07.2024.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSplash = true
    @State private var showOnboarding = false
    
    var body: some View {
        ZStack {
            SignInUpBackground()
            
            if showSplash {
                SplashScreenView(onSplashComplete: {
                    showSplash = false
                    // İlk açılışta onboarding gösterilecek mi kontrol et
                    let hasSeenOnboarding = UserDefaults.hasSeenOnboarding
                    if Utilities.Constants.onboarding || !hasSeenOnboarding {
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
                                    Text("home_tab".localized())
                                }
                            }
                        WallpaperView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "photo")
                                    Text("wallpapers_tab".localized())
                                }
                            }
                        CoupleQuestionView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "person.fill.questionmark")
                                    Text("couple_questions_tab".localized())
                                }
                            }
                        ProfileView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "person")
                                    Text("profile_tab".localized())
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
        .environmentObject(AppState())
}

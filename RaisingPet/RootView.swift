//
//  RootView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 30.07.2024.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var currentUserVM: CurrentUserViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    @State private var showSplash = true
    @State private var showOnboarding = false
    
    var body: some View {
        if networkMonitor.isConnected {
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
                                TabBarIcon(image: Image("home_tab_icon"), text: "home_tab".localized())
                            }
                        CoupleQuestionView()
                            .tabItem {
                                TabBarIcon(image: Image("couple_questions_tab_icon"), text: "couple_questions_tab".localized())
                            }
                        WallpaperView()
                            .tabItem {
                                TabBarIcon(image: Image("wallpaper_tab_icon"), text: "wallpapers_tab".localized())
                            }
                        ProfileView()
                            .tabItem {
                                TabBarIcon(image: Image("profile_tab_icon"), text: "profile_tab".localized())
                            }
                    }
                    .toolbarBackground(.gray.opacity(0.1), for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                }
                .onAppear {
                    if appState.isLoggedIn && currentUserVM.user == nil {
                        Task {
                            await currentUserVM.refresh()
                        }
                    }
                }
            } else {
                NavigationStack {
                    LoginView(onLoginSuccess: handleLoginSuccess)
                }
            }
            }
        } else {
            NoInternetView()
        }
    }
    
    private func handleLoginSuccess() {
        appState.isLoggedIn = true
        Task {
            await currentUserVM.refresh()
        }
    }
}

// TabBar ikonları için tutarlı görünüm sağlayan yardımcı bir görünüm
struct TabBarIcon: View {
    let image: Image
    let text: String
    
    var body: some View {
        VStack {
            image
                .resizable()
                .frame(width: 25, height: 25)
            Text(text)
                .font(.nunito(.medium, .caption211))
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
        .environmentObject(CurrentUserViewModel())
        .environmentObject(NetworkMonitor())
}

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
    @State private var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    @State private var selectedTab: Int = 0

    var body: some View {
        if networkMonitor.isConnected {
        ZStack {
            SignInUpBackground()

            if showSplash {
                SplashScreenView(onSplashComplete: {
                    showSplash = false
                    // İlk açılışta onboarding gösterilecek mi kontrol et
                    if ConstantManager.AppConfig.showOnboardingEveryTime || !hasSeenOnboarding {
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
                    TabView(selection: $selectedTab) {
                        HomeView()
                            .tabItem {
                                TabBarIcon(
                                    selectedImage: "homeTabIconSelected",
                                    unselectedImage: "homeTabIconUnselected",
                                    text: "home_tab".localized(),
                                    isSelected: selectedTab == 0
                                )
                            }
                            .tag(0)

                        CoupleQuestionView()
                            .tabItem {
                                TabBarIcon(
                                    selectedImage: "activityTabIconSelected",
                                    unselectedImage: "activityTabIconUnselected",
                                    text: "couple_questions_tab".localized(),
                                    isSelected: selectedTab == 1
                                )
                            }
                            .tag(1)

                        WallpaperView()
                            .tabItem {
                                TabBarIcon(
                                    selectedImage: "wallpaperTabIconSelected",
                                    unselectedImage: "wallpaperTabIconUnselected",
                                    text: "wallpapers_tab".localized(),
                                    isSelected: selectedTab == 2
                                )
                            }
                            .tag(2)

                        ProfileView()
                            .tabItem {
                                TabBarIcon(
                                    selectedImage: "profileTabIconSelected",
                                    unselectedImage: "profileTabIconUnselected",
                                    text: "profile_tab".localized(),
                                    isSelected: selectedTab == 3
                                )
                            }
                            .tag(3)
                    }
                    // .accentColor(Color("accentColor")) // Renkleri artık TabBarIcon içinde manuel ayarlıyoruz
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
    let selectedImage: String
    let unselectedImage: String
    let text: String
    let isSelected: Bool

    var body: some View {
        VStack {
            Image(isSelected ? selectedImage : unselectedImage)
                .renderingMode(.original) // Görsellerin orijinal renklerini koru
                .resizable()
                .scaledToFit() // Görseli çerçeveye sığdır, orantıyı koru
                .frame(width: 25, height: 25)
                .clipped()

            Text(text)
                .font(.nunito(.medium, .caption211))
                .foregroundColor(isSelected ? Color("accentColor") : .gray) // Renkleri manuel olarak ayarlıyoruz
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
        .environmentObject(CurrentUserViewModel())
        .environmentObject(NetworkMonitor())
}

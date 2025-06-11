//
//  RaisingPetApp.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI
import netfox
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
#if DEBUG
        // Netfox'u çalıştır
        NFX.sharedInstance().start()
#endif
        
        MobileAds.shared.start(completionHandler: nil)
        
        return true
    }
}

@main
struct RaisingPetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appState = AppState()
    @StateObject var currentUserVM = CurrentUserViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject private var interstitialManager = InterstitialAdsManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(currentUserVM)
                .environmentObject(networkMonitor)
                .environmentObject(interstitialManager)
                .onAppear {
                    if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                        Task {
                            currentUserVM.refresh()
                        }
                    } 
                    interstitialManager.loadInterstitialAd()
                }
        }
    }
}

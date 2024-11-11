//
//  RaisingPetApp.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct RaisingPetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var signUpViewModel = SignUpViewModel()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(loginViewModel)
                .environmentObject(signUpViewModel)
        }
    }
}

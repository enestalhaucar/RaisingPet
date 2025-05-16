//
//  ProfileViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.02.2025.
//

import Foundation

@MainActor
final class ProfileViewModel : ObservableObject {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository = UserRepositoryImpl()) {
        self.userRepository = userRepository
    }
    
    func logOut(appState : AppState) {
        userRepository.logOut()
        appState.isLoggedIn = false
        print("User logged out successfully")
    }
    
    func getUserDetailsForProfileView() -> [String:String] {
        let userDetails = userRepository.getUserDetails()
        print("ProfileView UserDetails Fetched: \(userDetails)")
        return userDetails
    }
}

//
//  ProfileViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.02.2025.
//

import Foundation

@MainActor
final class ProfileViewModel : ObservableObject {
    func logOut(appState : AppState) {
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        appState.isLoggedIn = false
        print("User logged out successfully")
    }
    
    func getUserDetailsForProfileView() -> [String:String] {
        var userDetails : [String:String] = [:]
        let tempUserDetails = Utilities.shared.getUserDetailsFromUserDefaults()
        userDetails = tempUserDetails
        print("ProfileView UserDetails Fetched :  \(userDetails)")
        return userDetails
    }
    
}

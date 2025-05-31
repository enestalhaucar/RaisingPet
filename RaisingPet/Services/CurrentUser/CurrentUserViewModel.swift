//
//  CurrentUserViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 5.05.2025.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class CurrentUserViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var user: GetMeUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var profileImage: UIImage?
    @Published var isAuthenticated: Bool = false

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let userProfileRepository: UserProfileRepository
    private let userRepository: UserRepository
    private let authRepository: AuthRepository
    
    // MARK: - Initialization
    init(
        userProfileRepository: UserProfileRepository = RepositoryProvider.shared.userProfileRepository,
        userRepository: UserRepository = RepositoryProvider.shared.userRepository,
        authRepository: AuthRepository = RepositoryProvider.shared.authRepository
    ) {
        self.userProfileRepository = userProfileRepository
        self.userRepository = userRepository
        self.authRepository = authRepository
        checkAuthenticationState()
    }

    // MARK: - Authentication State Management
    private func checkAuthenticationState() {
        if UserDefaults.standard.string(forKey: "authToken") != nil {
            self.isAuthenticated = true
            refresh()
        } else {
            self.isAuthenticated = false
        }
    }

    // MARK: - Data Management
    func refresh() {
        isLoading = true
        errorMessage = nil
        
        Task {
            guard UserDefaults.standard.string(forKey: "authToken") != nil else {
                logout()
                self.isLoading = false
                return
            }
            
            do {
                let response = try await userProfileRepository.getCurrentUser()
                self.user = response.data?.data
                print("Kullanıcı verisi güncellendi: \(self.user?.firstname ?? "N/A")")

                // UserDefaults'a kaydet
                if let user = response.data?.data {
                    saveUserDataToDefaults(user: user)
                    
                    // FriendsView'ı güncelle
                    NotificationCenter.default.post(name: NSNotification.Name("UserDataUpdated"), object: nil)
                }

                // Profil fotoğrafını yükle
                if let photoURLString = self.user?.photoURL, !photoURLString.isEmpty {
                    if self.profileImage == nil {
                         try await loadProfileImage(from: photoURLString)
                    }
                }
                
                self.isLoading = false
                self.isAuthenticated = true
                
            } catch let error as NetworkError {
                handleNetworkError(error)
                if case .unauthorized = error {
                    logout()
                }
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func saveUserDataToDefaults(user: GetMeUser) {
        UserDefaults.standard.set(user.firstname, forKey: "userFirstname")
        UserDefaults.standard.set(user.surname, forKey: "userSurname")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.friendTag, forKey: "userFriendTag")
        UserDefaults.standard.set(user.id, forKey: "userId")
        UserDefaults.standard.set(user.phoneNumber, forKey: "userPhoneNumber")
    }
    
    // MARK: - Logout
    func logout() {
        // UserDefaults temizle
        let keysToRemove = ["authToken", "userFirstname", "userSurname", "userEmail", 
                           "userFriendTag", "userId", "userPhoneNumber", "userProfilePhoto"]
        keysToRemove.forEach { UserDefaults.standard.removeObject(forKey: $0) }
        
        // State'i temizle
        self.isAuthenticated = false
        self.user = nil
        self.profileImage = nil
        self.isLoading = false
        self.errorMessage = nil
        
        print("Çıkış yapıldı - tüm oturum verileri temizlendi")
    }
    
    // MARK: - Helper Methods
    private func loadProfileImage(from urlString: String) async throws {
        do {
            let imageData = try await userRepository.getUserImage(imageURL: urlString)
            if let image = UIImage(data: imageData) {
                self.profileImage = image
                UserDefaults.standard.set(imageData, forKey: "userProfilePhoto")
            }
        } catch {
            print("Profil fotoğrafı indirilemedi: \(error)")
        }
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        switch error {
        case .serverError(let statusCode, let message):
            errorMessage = "Server error (\(statusCode)): \(message ?? "Unknown error")"
        case .unauthorized:
            errorMessage = "Oturum süresi dolmuş. Lütfen tekrar giriş yapın."
        case .timeOut:
            errorMessage = "İstek zaman aşımına uğradı. Lütfen tekrar deneyin."
        default:
            errorMessage = "Ağ hatası: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

//
//  LoginViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 16.11.2024.
//


import Foundation
import Combine

class LoginViewModel: ObservableObject {
    // View'a geri bildirim sağlamak için published değişkenler
    @Published var isLoading: Bool = false
    @Published var loginSuccess: Bool = false
    @Published var errorMessage: String?
    
    // Repository
    private let authRepository: AuthRepository
    
    // MARK: - Initialization
    init(authRepository: AuthRepository = RepositoryProvider.shared.authRepository) {
        self.authRepository = authRepository
    }
    
    func login(with email: String, password: String) {
        // İstek başlatılmadan önce durumu güncelle
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                let response = try await authRepository.login(email: email, password: password)
                
                // Başarılı giriş
                saveUserToUserDefaults(data: response)
                
                isLoading = false
                loginSuccess = true
                print("user logged in successfully")
            } catch let error as NetworkError {
                isLoading = false
                errorMessage = error.errorMessage
            } catch {
                isLoading = false
                errorMessage = "Bilinmeyen bir hata oluştu"
            }
        }
    }
    
    private func saveUserToUserDefaults(data: LoginResponseModel) {
        let defaults = UserDefaults.standard
        defaults.set(data.token, forKey: "authToken")
        defaults.set(data.data.user.firstname, forKey: "userFirstname")
        defaults.set(data.data.user.surname, forKey: "userSurname")
        defaults.set(data.data.user.email, forKey: "userEmail")
        defaults.set(data.data.user.friendTag, forKey: "userFriendTag")
        defaults.set(data.data.user._id, forKey: "userId")
        defaults.set(true, forKey: "isLoggedIn")
        
        defaults.synchronize() 
        
        print("User details saved to UserDefaults")
    }
}



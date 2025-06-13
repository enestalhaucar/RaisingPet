//
//  SignUpViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 16.11.2024.
//

import Foundation
import SwiftUI
import Combine

struct ServerError: Codable {
    let message: String
}

class SignUpViewModel: ObservableObject {
    @Published var isRegistered = false
    @Published var errorMessage: String?
    @Published var isLoading = false

    // Repository
    private let authRepository: AuthRepository

    // MARK: - Initialization
    init(authRepository: AuthRepository = RepositoryProvider.shared.authRepository) {
        self.authRepository = authRepository
    }

    func register(firstName: String, lastName: String, email: String, password: String, passwordConfirm: String) {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let response = try await authRepository.signup(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password,
                    passwordConfirm: passwordConfirm
                )

                // Başarılı kayıt
                saveUserToUserDefaults(data: response)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")

                isLoading = false
                isRegistered = true
            } catch let error as NetworkError {
                isLoading = false
                errorMessage = error.errorMessage
            } catch {
                isLoading = false
                errorMessage = "Bilinmeyen bir hata oluştu"
            }
        }
    }

    private func saveUserToUserDefaults(data: SignUpResponseBody) {
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

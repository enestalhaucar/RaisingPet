//
//  ProfileEditViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 10.05.2025.
//

import Foundation
import UIKit
import Combine

@MainActor
class ProfileEditViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isSuccess: Bool = false
    
    private let userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(userRepository: UserRepository = UserRepositoryImpl()) {
        self.userRepository = userRepository
    }
    
    func updateProfile(firstname: String? = nil, surname: String? = nil, phoneNumber: String? = nil, email: String? = nil, photo: UIImage? = nil) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            // Use comprehensive method that handles both text fields and photo
            let response = try await userRepository.updateProfileWithPhoto(
                firstName: firstname,
                lastName: surname,
                email: email,
                phoneNumber: phoneNumber,
                photo: photo
            )
            
            isSuccess = true
            print("Profile updated successfully: \(response)")
        } catch let error as NetworkError {
            handleNetworkError(error)
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
            print("Update profile error: \(error)")
        }
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        switch error {
        case .serverError(let statusCode, let message):
            errorMessage = "Server error (\(statusCode)): \(message ?? "Unknown error")"
        case .unauthorized:
            errorMessage = "Unauthorized access. Please log in again."
        case .timeOut:
            errorMessage = "Request timed out. Please try again."
        default:
            errorMessage = "Network error: \(error.localizedDescription)"
        }
    }
}

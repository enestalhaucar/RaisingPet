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

    // Simplified method that only updates the photo
    func updateProfile(photo: UIImage) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            // Use uploadProfilePhoto to just update the photo
            let response = try await userRepository.uploadProfilePhoto(photo: photo)

            isSuccess = true
            print("Profile photo updated successfully: \(response)")
        } catch let error as NetworkError {
            handleNetworkError(error)
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
            print("Update profile photo error: \(error)")
        }
    }

    // Method to get the user's profile image from URL
    func getUserProfileImage(photoURL: String) async throws -> Data {
        do {
            let imageData = try await userRepository.getUserImage(imageURL: photoURL)
            return imageData
        } catch {
            print("Error getting profile image: \(error)")
            throw error
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

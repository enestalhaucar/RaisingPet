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
    @Published var user: GetMeUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var profileImage: UIImage?

    private var cancellables = Set<AnyCancellable>()
    private let userProfileRepository: UserProfileRepository
    private let userRepository: UserRepository
    
    init(
        userProfileRepository: UserProfileRepository = RepositoryProvider.shared.userProfileRepository,
        userRepository: UserRepository = RepositoryProvider.shared.userRepository
    ) {
        self.userProfileRepository = userProfileRepository
        self.userRepository = userRepository
    }

    func refresh() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await userProfileRepository.getCurrentUser()
                self.user = response.data?.data
                
                // Load profile image if available
                if let photoURL = self.user?.photoURL, !photoURL.isEmpty {
                    try await loadProfileImage(from: photoURL)
                }
                
                self.isLoading = false
            } catch let error as NetworkError {
                handleNetworkError(error)
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func loadProfileImage(from urlString: String) async throws {
        do {
            let imageData = try await userRepository.getUserImage(imageURL: urlString)
            if let image = UIImage(data: imageData) {
                self.profileImage = image
                // Cache the image
                UserDefaults.standard.set(imageData, forKey: "userProfilePhoto")
            }
        } catch {
            print("Failed to load profile image: \(error)")
            // This is not a critical error, so we don't set errorMessage
        }
    }
    
    // Alternative implementation using Combine
    func refreshWithCombine() {
        isLoading = true
        errorMessage = nil
        
        userProfileRepository.getCurrentUserPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.handleNetworkError(error)
                }
            } receiveValue: { [weak self] response in
                self?.user = response.data?.data
            }
            .store(in: &cancellables)
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
        isLoading = false
    }
}

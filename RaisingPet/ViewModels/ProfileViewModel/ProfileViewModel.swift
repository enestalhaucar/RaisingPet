//
//  ProfileViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.02.2025.
//

import Foundation
import UIKit

@MainActor
final class ProfileViewModel: ObservableObject {
    private let userRepository: UserRepository
    @Published var profileImage: UIImage?
    @Published var isLoadingImage: Bool = false
    @Published var imageError: String?
    private var notificationObserver: NSObjectProtocol?

    init(userRepository: UserRepository = RepositoryProvider.shared.userRepository) {
        self.userRepository = userRepository
        setupNotifications()
    }

    deinit {
        // Clean up observers when view model is deallocated
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func setupNotifications() {
        // Register for profile image update notifications
        notificationObserver = NotificationCenter.default.addObserver(
            forName: .profileImageUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            // When notification is received, load image from UserDefaults
            if let photoData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
               let image = UIImage(data: photoData),
               let self = self {
                self.profileImage = image
            }
        }
    }

    // Load profile image from cache or UserDefaults
    func loadProfileImageFromCache() {
        if let photoData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
           let image = UIImage(data: photoData) {
            self.profileImage = image
        }
    }

    func logOut(appState: AppState) {
        userRepository.logOut()
        appState.isLoggedIn = false
        print("User logged out successfully")
    }

    func getUserDetailsForProfileView() -> [String: String] {
        let userDetails = userRepository.getUserDetails()
        print("ProfileView UserDetails Fetched: \(userDetails)")
        return userDetails
    }

    func loadProfileImage(from urlString: String) async {
        guard !urlString.isEmpty, urlString != "N/A" else {
            return
        }

        isLoadingImage = true
        imageError = nil

        do {
            let imageData = try await userRepository.getUserImage(imageURL: urlString)
            if let image = UIImage(data: imageData) {
                self.profileImage = image
                // Cache the image for future use
                UserDefaults.standard.set(imageData, forKey: "userProfilePhoto")
            } else {
                self.imageError = "Invalid image data"
            }
        } catch {
            print("Failed to load profile image: \(error)")
            self.imageError = error.localizedDescription

            // Try to load from cache as fallback
            if let cachedImageData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
               let cachedImage = UIImage(data: cachedImageData) {
                self.profileImage = cachedImage
            }
        }

        isLoadingImage = false
    }
}

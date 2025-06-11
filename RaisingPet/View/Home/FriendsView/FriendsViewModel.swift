//
//  FriendsViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 10.12.2024.
//


import Foundation
import Combine

@MainActor
class FriendsViewModel: ObservableObject {
    @Published private(set) var friends: [Friend] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Repository
    private let friendsRepository: FriendsRepository
    
    // MARK: - Initialization
    init(friendsRepository: FriendsRepository = RepositoryProvider.shared.friendsRepository) {
        self.friendsRepository = friendsRepository
    }

    // GET: Friends List
    func fetchFriendsList() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await friendsRepository.listFriends()
            self.friends = response.data.friends
            
            // Eğer arkadaş listesi boş değilse ve ilk arkadaş varsa, bilgilerini kaydet.
            if let friend = self.friends.first {
                Utilities.shared.saveFriendDetailsToUserDefaults(firstname: friend.friend.firstname, id: friend.friend._id)
            } else {
                // Eğer arkadaş listesi boşsa, UserDefaults'tan bilgileri temizle.
                Utilities.shared.clearFriendDetailsFromUserDefaults()
            }
            
        } catch let error as NetworkError {
            handleNetworkError(error)
        } catch {
            errorMessage = "Arkadaş listesi yüklenemedi: \(error.localizedDescription)"
            print("Fetch friends error: \(error)")
        }
    }

    // POST: Accept Friend Request
    func acceptFriendRequest(requestId: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await friendsRepository.acceptRequest(requestId: requestId)
            await fetchFriendsList() // Kabul sonrası listeyi güncelle
        } catch let error as NetworkError {
            handleNetworkError(error)
            throw error
        } catch {
            errorMessage = "Arkadaşlık isteği kabul edilemedi: \(error.localizedDescription)"
            print("Accept friend request error: \(error)")
            throw error
        }
    }

    // POST: Reject Friend Request
    func rejectFriendRequest(requestId: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await friendsRepository.rejectRequest(requestId: requestId)
            await fetchFriendsList() // Reddetme sonrası listeyi güncelle
        } catch let error as NetworkError {
            handleNetworkError(error)
            throw error
        } catch {
            errorMessage = "Arkadaşlık isteği reddedilemedi: \(error.localizedDescription)"
            print("Reject friend request error: \(error)")
            throw error
        }
    }

    // POST: Remove Friend
    func removeFriend(friendId: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await friendsRepository.removeFriend(friendId: friendId)
            await fetchFriendsList() // Silme sonrası listeyi güncelle
        } catch let error as NetworkError {
            handleNetworkError(error)
            throw error
        } catch {
            errorMessage = "Arkadaş silme başarısız: \(error.localizedDescription)"
            print("Remove friend error: \(error)")
            throw error
        }
    }

    // MARK: - Helper Methods
    
    // Yardımcı Fonksiyonlar
    var pendingFriends: [Friend] {
        friends.filter { $0.status == "pending" }
    }

    var acceptedFriends: [Friend] {
        friends.filter { $0.status == "accepted" }
    }
    
    // MARK: - Error Handling
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

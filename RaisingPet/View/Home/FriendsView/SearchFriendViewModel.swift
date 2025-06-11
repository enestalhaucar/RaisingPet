//
//  SearchFriendViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 20.07.2024.
//

import Foundation
import Combine

@MainActor
class SearchFriendViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var searchedFriend: SearchFriendWithTagDataUser?
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    // Repository
    private let friendsRepository: FriendsRepository
    
    // Combine
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(friendsRepository: FriendsRepository = RepositoryProvider.shared.friendsRepository) {
        self.friendsRepository = friendsRepository
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher() {
        $searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self = self else { return }
                if searchText.isEmpty {
                    self.searchedFriend = nil
                } else {
                    Task {
                        await self.searchFriendWithTag(searchText)
                    }
                }
            }
            .store(in: &cancellables)
    }

    // POST: Search Friend by Tag
    func searchFriendWithTag(_ friendTag: String) async {
        isLoading = true
        errorMessage = nil
        // Arama başladıgında bir önceki aranan kullanıcıyı siliyoruz.
        self.searchedFriend = nil
        
        defer { isLoading = false }

        guard !friendTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.searchedFriend = nil
            return
        }

        do {
            let response = try await friendsRepository.searchFriendWithTag(tag: friendTag)
            self.searchedFriend = response.data.user
        } catch let error as NetworkError {
            switch error {
            case .serverError(let statusCode, _):
                if statusCode == 404 {
                    self.searchedFriend = nil
                    self.errorMessage = "There is no such user"
                    print("Kullanıcı bulunamadı (404), alert gösterilmeyecek.")
                } else {
                    self.handleNetworkError(error)
                    self.searchedFriend = nil
                }
            case .timeOut, .noInternetConnection, .unauthorized:
                self.handleNetworkError(error)
                self.searchedFriend = nil
            default:
                print("searchFriendWithTag NetworkError (alert gösterilmeyecek): \(error.localizedDescription)")
                self.searchedFriend = nil
            }
        } catch {
            print("Search friend error (diğer): \(error.localizedDescription)")
            self.searchedFriend = nil
        }
    }

    // POST: Send Friend Request
    func sendFriendRequest(friendId: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await friendsRepository.sendRequest(friendId: friendId)
            self.searchedFriend = nil
            self.searchText = ""
            return true // Başarılı
        } catch let error as NetworkError {
            handleNetworkError(error)
            return false // Başarısız
        } catch {
            errorMessage = "Friend request could not be sent: \(error.localizedDescription)"
            print("Send friend request error: \(error)")
            return false // Başarısız
        }
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
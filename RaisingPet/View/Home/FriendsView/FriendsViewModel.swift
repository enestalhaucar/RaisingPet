//
//  FriendsViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 10.12.2024.
//


import Foundation
import Alamofire

@MainActor
class FriendsViewModel: ObservableObject {
    @Published private(set) var friends: [Friend] = []
    @Published var isLoading = false
    @Published var searchedFriend: SearchFriendWithTagDataUser = .init(id: "", firstname: "", surname: "", email: "", photo: "", role: "", gameCurrencyGold: 0, gameCurrencyDiamond: 0, friendTag: "", v: 0)
    @Published var errorMessage: String?

    private var headers: HTTPHeaders {
        let token = Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? ""
        return [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
    }

    // GET: Friends List
    func fetchFriendsList() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = Utilities.Constants.Endpoints.Friends.list

        do {
            let response = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(FriendResponse.self)
                .value
            friends = response.data.friends
        } catch {
            errorMessage = "Arkadaş listesi yüklenemedi: \(error.localizedDescription)"
            print("Fetch friends error: \(error)")
        }
    }

    // POST: Search Friend by Tag
    func searchFriendWithTag(_ friendTag: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = Utilities.Constants.Endpoints.Friends.searchFriendWithTag
        let parameters = ["friendTag": friendTag]

        do {
            let response = try await AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .serializingDecodable(SearchFriendWithTagResponse.self)
                .value
            searchedFriend = response.data.user ?? .init(id: "", firstname: "", surname: "", email: "", photo: "", role: "", gameCurrencyGold: 0, gameCurrencyDiamond: 0, friendTag: "", v: 0)
        } catch {
            errorMessage = "Arkadaş arama başarısız: \(friendTag) için kullanıcı bulunamadı. \(error.localizedDescription)"
            print("Search friend error: \(error)")
            searchedFriend = .init(id: "", firstname: "", surname: "", email: "", photo: "", role: "", gameCurrencyGold: 0, gameCurrencyDiamond: 0, friendTag: "", v: 0)
        }
    }

    // POST: Send Friend Request
    func sendFriendRequest(friendId: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = Utilities.Constants.Endpoints.Friends.sendRequest
        let parameters = ["friendId": friendId]

        do {
            let response = try await AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .serializingDecodable(FriendRequestResponse.self)
                .value
            await fetchFriendsList() // İstek sonrası listeyi güncelle
        } catch {
            errorMessage = "Arkadaşlık isteği gönderilemedi: \(error.localizedDescription)"
            print("Send friend request error: \(error)")
            throw error
        }
    }

    // POST: Accept Friend Request
    func acceptFriendRequest(friendId: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = Utilities.Constants.Endpoints.Friends.acceptRequest
        let parameters = ["friendId": friendId]

        do {
            let response = try await AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .serializingDecodable(FriendRequestResponse.self)
                .value
            await fetchFriendsList() // Kabul sonrası listeyi güncelle
        } catch {
            errorMessage = "Arkadaşlık isteği kabul edilemedi: \(error.localizedDescription)"
            print("Accept friend request error: \(error)")
            throw error
        }
    }

    // POST: Reject Friend Request
    func rejectFriendRequest(friendId: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = Utilities.Constants.Endpoints.Friends.rejectRequest
        let parameters = ["friendId": friendId]

        do {
            let response = try await AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
            if let httpResponse = response.response, httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                await fetchFriendsList() // Reddetme sonrası listeyi güncelle
            } else {
                throw AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: response.response?.statusCode ?? 500))
            }
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

        let url = Utilities.Constants.Endpoints.Friends.removeFriend
        let parameters = ["friendId": friendId]

        do {
            let response = try await AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .serializingDecodable(FriendRequestResponse.self)
                .value
            if response.data.friendRequest.status == "removed" && response.data.friendRequest.isDeleted {
                await fetchFriendsList() // Silme sonrası listeyi güncelle
            } else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Arkadaş silme işlemi başarısız: Beklenmeyen response"])
            }
        } catch {
            errorMessage = "Arkadaş silme başarısız: \(error.localizedDescription)"
            print("Remove friend error: \(error)")
            throw error
        }
    }

    // Yardımcı Fonksiyonlar
    var pendingFriends: [Friend] {
        friends.filter { $0.status == "pending" }
    }

    var acceptedFriends: [Friend] {
        friends.filter { $0.status == "accepted" }
    }
}

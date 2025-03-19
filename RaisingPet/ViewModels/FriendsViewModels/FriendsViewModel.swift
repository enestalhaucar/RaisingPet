//
//  FriendsViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 10.12.2024.
//


import Foundation
import Alamofire

class FriendsViewModel: ObservableObject {
    @Published private(set) var friends: [Friend] = []
    @Published var isLoading = false
    @Published var searchedFriend : SearchFriendWithTagDataUser = .init(id: "", firstname: "Örnek", surname: "Örnek", email: "ornek@gmail.com", photo: "-", role: "-", gameCurrency: 0, friendTag: "-", v: 0)
    
    func fetchFriendsList() {
        isLoading = true
        let userDetails = Utilities.shared.getUserDetailsFromUserDefaults()
        let apiUrl = Utilities.Constants.Endpoints.Friends.list
        guard let token = userDetails["token"], !token.isEmpty else {
            print("Error: Missing auth token")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(apiUrl, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: FriendResponse.self) { response in
                switch response.result {
                case .success(let friendResponse):
                    print("Response: \(friendResponse)")
                    self.friends = friendResponse.data.friends
                    self.isLoading = false
                case .failure(let error):
                    if let data = response.data,
                       let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                        print("Server Error: \(serverError.message)")
                    } else {
                        print("Failed to fetch friends: \(error.localizedDescription)")
                    }
                    self.isLoading = false
                }
            }
    }
    
    func searchFriendWithTag(_ friendTag: String) {
        isLoading = true
        let url = Utilities.Constants.Endpoints.Friends.searchFriendWithTag
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        
        let parameters = ["friendTag": friendTag]
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: SearchFriendWithTagResponse.self ) { response in
                switch response.result {
                case .success(let friendTagResponse):
                    self.searchedFriend = friendTagResponse.data.user
                    self.isLoading = false
                case .failure(let error):
                    print("Hata SearchFriendWithTag : \(error)")
                    self.isLoading = false
                }
            }
    }
}

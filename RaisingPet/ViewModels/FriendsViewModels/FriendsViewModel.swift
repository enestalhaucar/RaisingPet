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
    private let apiUrl = Utilities.Constants.Endpoints.Friends.list
    
    func fetchFriends() {
        let userDetails = Utilities.shared.getUserDetailsFromUserDefaults()
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
                case .failure(let error):
                    if let data = response.data,
                       let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                        print("Server Error: \(serverError.message)")
                    } else {
                        print("Failed to fetch friends: \(error.localizedDescription)")
                    }
                }
            }
    }
}

//
//  FriendsViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 10.12.2024.
//

import Foundation
import Alamofire

class FriendsViewModel: ObservableObject {
    @Published var friends: [Friend] = []
        private let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MTM3M2FmMzNmNzc2NjFiYzVlNWNkYiIsImlhdCI6MTczMzg0NTE1OCwiZXhwIjoxNzQxNjIxMTU4fQ.IUZQT0gbA835Bmbv3ccHZ1p6WMoHYHNWFef2NWa6JjA"
        private let apiUrl = "http://3.74.213.54:3000/api/v1/friends/list" // API URL'yi değiştirin

        func fetchFriends() {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)"
            ]
            
            AF.request(apiUrl, method: .get, headers: headers)
                .validate() // Status kodu ve içerik doğrulama
                .responseDecodable(of: FriendResponse.self) { response in
                    switch response.result {
                    case .success(let friendResponse):
                        // Gelen response'u loglayalım
                        print("Response: \(friendResponse)")
                        self.friends = friendResponse.data.friends
                    case .failure(let error):
                        print("Failed to fetch friends: \(error.localizedDescription)")
                    }
                }
        }
}

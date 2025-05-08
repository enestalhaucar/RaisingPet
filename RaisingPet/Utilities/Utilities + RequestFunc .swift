//
//  Utilities + RequestFunc .swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 5.05.2025.
//

import Alamofire
import Foundation

extension Utilities {
    func fetchCurrentUser(completion: @escaping (Result<GetMeUser, AFError>) -> Void) {
        let url = Constants.Endpoints.Auth.me
        let token = getUserDetailsFromUserDefaults()["token"] ?? ""
        print("Fetched Token: \(token)")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: GetMeResponse.self) { response in
                switch response.result {
                case .success(let wrapper):
                    completion(.success(wrapper.data.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

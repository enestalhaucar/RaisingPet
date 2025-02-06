//
//  SignUpViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 16.11.2024.
//

import Foundation
import SwiftUI
import Alamofire

struct ServerError: Codable {
    let message: String
}


class SignUpViewModel: ObservableObject {
    @Published var token : String?
    @Published var isRegistered = false
    @Published var errorMessage: String?
    var isLoading: ((Bool) -> Void)?
    
    
    
    func register(with body: SignUpRequestBody) {
        let url = Utilities.Constants.Endpoints.Auth.signup
        
        isLoading?(true)
        
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: SignUpResponseBody.self) { [weak self] response in
                DispatchQueue.main.async {
                    self?.isLoading?(false)
                    switch response.result {
                    case .success(let data):
                        // Kullanıcı Bilgilerini Local'e Kaydetme
                        self?.saveUserToUserDefaults(data: data)
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        print("Token saved: \(data.token)")
                        self?.isRegistered = true // Kayıt başarıyla tamamlandı
                    case .failure(let error):
                        if let data = response.data,
                           let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                            self?.errorMessage = serverError.message
                        } else {
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
    }
    
    private func saveUserToUserDefaults(data: SignUpResponseBody) {
        UserDefaults.standard.set(data.token, forKey: "authToken")
        UserDefaults.standard.set(data.data.user.firstname, forKey: "userFirstname")
        UserDefaults.standard.set(data.data.user.surname, forKey: "userSurname")
        UserDefaults.standard.set(data.data.user.email, forKey: "userEmail")
        UserDefaults.standard.set(data.data.user.friendTag, forKey: "userFriendTag")
        UserDefaults.standard.set(data.data.user._id, forKey: "userId")
        print("User details saved to UserDefaults")
    }
    
}

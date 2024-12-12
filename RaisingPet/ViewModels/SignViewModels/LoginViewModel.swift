//
//  LoginViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 16.11.2024.
//


import Foundation
import Alamofire

class LoginViewModel: ObservableObject {
    // View'a geri bildirim sağlamak için published değişkenler
    @Published var isLoading: Bool = false
    @Published var loginSuccess: Bool = false
    @Published var errorMessage: String?
    
    func login(with email: String, password: String) {
        let url = "http://3.74.213.54:3000/api/v1/users/login" // Backend login endpoint'i
        let requestBody = LoginRequestBody(email: email, password: password)

        // İstek başlatılmadan önce durumu güncelle
        isLoading = true

        // Alamofire request
        AF.request(url,
                   method: .post,
                   parameters: requestBody,
                   encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { [weak self] response in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch response.result {
                    case .success(let data):
                        // Başarılı giriş
                        self?.saveUserToUserDefaults(data: data)
                        
                        self?.loginSuccess = true
                        print("user logged in succesfully")
                    case .failure(let error):
                        // Hata yönetimi
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
    
    private func saveUserToUserDefaults(data: LoginResponse) {
        UserDefaults.standard.set(data.token, forKey: "authToken")
        UserDefaults.standard.set(data.data.user.firstname, forKey: "userFirstname")
        UserDefaults.standard.set(data.data.user.surname, forKey: "userSurname")
        UserDefaults.standard.set(data.data.user.email, forKey: "userEmail")
        UserDefaults.standard.set(data.data.user.friendTag, forKey: "userFriendTag")
        UserDefaults.standard.set(data.data.user._id, forKey: "userId")
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        print("User details saved to UserDefaults")
    }
}



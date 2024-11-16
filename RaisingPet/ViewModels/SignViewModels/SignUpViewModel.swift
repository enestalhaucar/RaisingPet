//
//  SignUpViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 16.11.2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var token: String?
    @Published var isRegistered = false
    private var signUpURL = "http://3.74.213.54:3000/api/v1/users/signup"
    private var cancellables = Set<AnyCancellable>()
    
    private let appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    func register(firstname: String, surname: String, email: String, password: String, passwordConfirm: String) {
        guard let url = URL(string: signUpURL) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = SignUpRequestBody(
            firstname: firstname,
            surname: surname,
            email: email,
            password: password,
            passwordConfirm: passwordConfirm
        )
        
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Sign Up failed with error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] data in
                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    self?.token = response.token
                    self?.isRegistered = response.status == "success"
                    print("\(response.status)")
                    
                    // Save Token
                    UserDefaults.standard.set(response.token, forKey: "userToken")
                    self?.appViewModel.isLoggedIn = true
                    
                    print("Token received: \(response.token)")
                } catch {
                    print("Decoding failed with error: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)
    }
}

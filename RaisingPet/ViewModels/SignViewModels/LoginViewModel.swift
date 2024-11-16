//
//  LoginViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 16.11.2024.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var token: String?
    @Published var isLoggedIn = false
    private var loginURL = "http://3.74.213.54:3000/api/v1/users/login"
    private var cancellables = Set<AnyCancellable>()
    
    private let appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    
    func login(email: String, password: String) {
        guard let url = URL(string: loginURL) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Login failed with error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] data in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON response: \(jsonString)")
                    
                }
                
                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    self?.token = response.token
                    self?.isLoggedIn = response.status == "success"
                    print("\(response.status)")
                    
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

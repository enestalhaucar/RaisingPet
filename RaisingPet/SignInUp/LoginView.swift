//
//  SignInView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var token: String?
    @Published var isLoggedIn = false
    private var loginURL = "http://3.74.213.54:3000/api/v1/users/login"
    
    private var cancellables = Set<AnyCancellable>()
    
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
                    print("Token received: \(response.token)")
                    
                    
                } catch {
                    print("Decoding failed with error: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)
    }
}


struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    

    
    @State private var email = "omerdmn1@hotmail.com"
    @State private var password = "Renekton1"
    
    var body: some View {
        NavigationStack {
            ZStack {
                SignInUpBackground()
                
                VStack(spacing: 25) {
                    Spacer()
                    Spacer()
                    Text("Welcome Back!")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Image("signInDog")
                    Spacer()
                    MailTextField(placeholder: "Enter Your Email", text: $email)
                    PasswordTextField(placeholder: "Enter Your Password", text: $password)
                    
                    NavigationLink {
                        
                    } label: {
                        Text("Forgot Password")
                            .foregroundStyle(Color("buttonBackgroundColor"))
                            .font(.headline)
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        viewModel.login(email: email, password: password)
                        
                    } label: {
                        Text("Sign In")
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 50)
                            .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                        
                    }
                    
                    HStack {
                        Text("Don't you have an account ?")
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("Sign Up")
                                .foregroundStyle(Color("buttonBackgroundColor"))
                        }
                        
                    }
                    
                    
                    
                }.padding()
                
            }
        }
    }
}

#Preview {
    LoginView()
}

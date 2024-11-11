//
//  RegisterView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Combine




@MainActor
class SignUpViewModel: ObservableObject {
    @Published var token: String?
    @Published var isRegistered = false
    
    private var signUpURL = "http://3.74.213.54:3000/api/v1/users/signup"
    private var cancellables = Set<AnyCancellable>()
    
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
                    
                    // Save Token
                    UserDefaults.standard.set(response.token, forKey: "userToken")
                    
                    
                    print("Token received: \(response.token)")
                } catch {
                    print("Decoding failed with error: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)
    }
}


struct SignUpView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    @State private var firstname = ""
       @State private var surname = ""
       @State private var email = ""
       @State private var password = ""
       @State private var passwordConfirm = ""
       
    
    var body: some View {
        NavigationStack {
            ZStack {
                SignInUpBackground()
                
                VStack(spacing: 25) {
                    Spacer()
                    Text("Welcome Onboard")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Let's help you meet your pet")
                        .font(.headline)
                        .fontWeight(.regular)
                    
                    Spacer()
                    MailTextField(placeholder: "Enter your Firstname", text: $firstname)
                    MailTextField(placeholder: "Enter your Surname", text: $surname)
                    MailTextField(placeholder: "Enter your email", text: $email)
                    PasswordTextField(placeholder: "Enter Your Password", text: $password)
                    PasswordTextField(placeholder: "Enter Your Password Again", text: $passwordConfirm)
                    
                    
                    
                    
                    Spacer()
                    Button(action: {
                        if !firstname.isEmpty, !surname.isEmpty, !email.isEmpty, !password.isEmpty, !passwordConfirm.isEmpty, passwordConfirm == password {
                            signUpViewModel.register(firstname: firstname, surname: surname, email: email, password: password, passwordConfirm: passwordConfirm)
                        }
                    }, label: {
                        if password == passwordConfirm, !password.isEmpty, !passwordConfirm.isEmpty {
                            Text("Sign Up")
                                .foregroundStyle(.white)
                                .frame(width: 250, height: 50)
                                .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                        } else {
                            Text("Sign Up")
                                .foregroundStyle(.white)
                                .frame(width: 250, height: 50)
                                .background(Color("buttonBackgroundColor").opacity(0.3), in: .rect(cornerRadius: 25))
                        }
                    })
                    
                  
                    
                    HStack(spacing: 15) {
//                        GoogleSignInButton(scheme: .light, style: .icon, state: .normal) {
//                            Task {
//                                do {
//                                    try await viewModel.signInGoogle()
//                                    isSuccess = false
//                                    print(isSuccess)
//                                } catch {
//                                    print("error while google  + \(error)")
//                                }
//                            }
//                        }
                        Image("Apple")
                        Image("Facebook")
                            
                    }
                    HStack {
                        Text("Already have an account ?")
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Sign In")
                                .foregroundStyle(Color("buttonBackgroundColor"))
                        }

                    }
                }.padding()   
            }
        }
    }
}

#Preview {
    SignUpView()
}



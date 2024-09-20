//
//  RegisterView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift


@MainActor
final class SignUpViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var repassword = ""
    
    
    func signUp() async throws{
        guard !email.isEmpty, !password.isEmpty else {
            print("No mail or password or name")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        print(authDataResult)
        try await UserManager.shared.createNewUser(auth: authDataResult)
        print("success")
    }
    
    func signInGoogle() async throws {
        let helper = GoogleSignInHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        print(authDataResult)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}


struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @Binding var isSuccess : Bool
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
                    
                    
                    MailTextField(placeholder: "Enter your email", text: $viewModel.email)
                    PasswordTextField(placeholder: "Enter Your Password", text: $viewModel.password)
                    PasswordTextField(placeholder: "Enter Your Password Again", text: $viewModel.repassword)
                    
                    
                    
                    
                    Spacer()
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.signUp()
                                isSuccess = false
                                print(isSuccess)
                            } catch {
                                print("error while signUp from signupview")
                            }
                        }
                    }, label: {
                        if viewModel.password == viewModel.repassword, !viewModel.password.isEmpty, !viewModel.password.isEmpty {
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
                        GoogleSignInButton(scheme: .light, style: .icon, state: .normal) {
                            Task {
                                do {
                                    try await viewModel.signInGoogle()
                                    isSuccess = false
                                    print(isSuccess)
                                } catch {
                                    print("error while google  + \(error)")
                                }
                            }
                        }
                        Image("Apple")
                        Image("Facebook")
                            
                    }
                    HStack {
                        Text("Already have an account ?")
                        NavigationLink {
                            SignInView(isSuccess: $isSuccess)
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
    SignUpView(isSuccess: .constant(false))
}

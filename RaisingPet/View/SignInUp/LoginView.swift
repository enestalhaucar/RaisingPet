//
//  SignInView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI
import Combine

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var email = "omerdmn1@hotmail.com"
    @State private var password = "Renekton1"
    @State private var showError = false
    @EnvironmentObject var appState: AppState
    var onLoginSuccess: () -> Void
    
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
                    
                    
                    Spacer()
                    
                    
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button(action: {
                            viewModel.login(with: email, password: password)
                        }) {
                            Text("Log In")
                                .foregroundStyle(.white)
                                .frame(width: 250, height: 50)
                                .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                        }
                        .disabled(email.isEmpty || password.isEmpty)
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        Text("Forgot Password")
                            .foregroundStyle(Color("buttonBackgroundColor"))
                            .font(.headline)
                    }
                    
                    
                    
                    
                    HStack {
                        Text("Don't you have an account ?")
                        NavigationLink {
                            SignUpView {
                                print("register successfull")
                            }
                        } label: {
                            Text("Sign Up")
                                .foregroundStyle(Color("buttonBackgroundColor"))
                        }
                        
                    }
                    
                    
                    
                }.padding()
                    .onChange(of: viewModel.loginSuccess) { success in
                        if success {
                            appState.isLoggedIn = true
                            onLoginSuccess()
                        }
                    }
                    .onChange(of: viewModel.errorMessage) { error in
                        if let error = error {
                            showError = true
                        }
                    }
                    .alert(isPresented: $showError) {
                        Alert(
                            title: Text("Login Error"),
                            message: Text(viewModel.errorMessage ?? "Unknown error"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                
            }
        }
    }
}

#Preview {
    LoginView {
        print("login successfull")
    }
}



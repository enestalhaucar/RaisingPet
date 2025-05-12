//
//  SignInView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 29.07.2024.
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
                    Text("signin_welcome_title".localized())
                        .font(.title3)
                        .fontWeight(.semibold)
                    Image("signInDog")
                    Spacer()
                    MailTextField(placeholder: "signin_email_placeholder".localized(), text: $email)
                    PasswordTextField(placeholder: "signin_password_placeholder".localized(), text: $password)
                    
                    Spacer()
                    
                    if viewModel.isLoading {
                        LoadingAnimationView()
                    } else {
                        Button(action: {
                            viewModel.login(with: email, password: password)
                        }) {
                            Text("signin_button".localized())
                                .foregroundStyle(.white)
                                .frame(width: 250, height: 50)
                                .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                        }
                        .disabled(email.isEmpty || password.isEmpty)
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        Text("signin_forgot_password".localized())
                            .foregroundStyle(Color("buttonBackgroundColor"))
                            .font(.headline)
                    }
                    
                    HStack {
                        Text("signin_no_account".localized())
                        NavigationLink {
                            SignUpView {
                                print("register successfull")
                            }
                        } label: {
                            Text("signup_button".localized())
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
                            title: Text("signin_error_title".localized()),
                            message: Text(viewModel.errorMessage ?? "signin_unknown_error".localized()),
                            dismissButton: .default(Text("signin_alert_ok".localized()))
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

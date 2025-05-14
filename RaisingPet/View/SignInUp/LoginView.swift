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
    @State private var email = ""
    @State private var password = ""
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
                        .submitLabel(.next)
                        .onSubmit {
                            focusNextField($password)
                        }
                    PasswordTextField(placeholder: "signin_password_placeholder".localized(), text: $password)
                        .submitLabel(.done)
                        .onSubmit {
                            viewModel.login(with: email, password: password)
                        }
                    
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
                        .opacity((email.isEmpty || password.isEmpty) ? 0.5 : 1.0)
                    }
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("signin_forgot_password".localized())
                            .foregroundStyle(Color("buttonBackgroundColor"))
                            .font(.headline)
                    }
                    
                    HStack {
                        Text("signin_no_account".localized())
                        NavigationLink {
                            SignUpView(onRegisterSuccess: onLoginSuccess)
                        } label: {
                            Text("signup_button".localized())
                                .foregroundStyle(Color("buttonBackgroundColor"))
                        }
                    }
                }
                .padding()
                .onChange(of: viewModel.loginSuccess) { _, success in
                    if success {
                        appState.isLoggedIn = true
                        onLoginSuccess()
                    }
                }
                .onChange(of: viewModel.errorMessage) { _, error in
                    if error != nil {
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
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func focusNextField(_ nextField: Binding<String>) {
        // Şu an focus otomatik olarak bir sonraki field’a geçiyor
    }
}

#Preview {
    LoginView {
        print("login successful!")
    }
}

//
//  SignInView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 29.07.2024.
//

import SwiftUI
import Combine

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject private var currentUserVM: CurrentUserViewModel
    @EnvironmentObject private var appState: AppState
    
    // Focus state değişkenleri
    @FocusState private var emailFocused: Bool
    @FocusState private var passwordFocused: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    
    var onLoginSuccess: () -> Void

    var body: some View {
        ZStack {
            SignInUpBackground()
            
            // Klavye dışına dokununca klavyeyi gizle
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }
            
            VStack(spacing: 25) {
                Spacer()
                Spacer()
                Text("signin_welcome_title".localized())
                    .font(.title3)
                    .fontWeight(.semibold)
                Image("signInDog")
                Spacer()
                MailTextField(placeholder: "signin_email_placeholder".localized(), text: $email)
                    .focused($emailFocused)
                    .submitLabel(.next)
                    .onSubmit {
                        passwordFocused = true
                    }
                PasswordTextField(placeholder: "signin_password_placeholder".localized(), text: $password)
                    .focused($passwordFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        hideKeyboard()
                        viewModel.login(with: email, password: password)
                    }
                
                Spacer()
                
                if viewModel.isLoading {
                    LoadingAnimationView()
                } else {
                    Button(action: {
                        hideKeyboard()
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
                    Text("Coming Soon")
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
            .onChange(of: currentUserVM.isAuthenticated) { _, authenticated in
                if authenticated {
                    appState.isLoggedIn = true
                    onLoginSuccess()
                }
            }
            .onChange(of: currentUserVM.errorMessage) { _, error in
                if error != nil {
                    self.viewModel.errorMessage = currentUserVM.errorMessage
                    self.showError = true
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
    }
    
    // Klavyeyi gizleme fonksiyonu
    private func hideKeyboard() {
        emailFocused = false
        passwordFocused = false
    }
}

#Preview {
    LoginView {
        print("login successful!")
    }
    .environmentObject(AppState())
    .environmentObject(CurrentUserViewModel())
}

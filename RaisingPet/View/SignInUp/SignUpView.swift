//
//  RegisterView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 29.07.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Combine

struct SignUpView: View {
    @StateObject var viewModel = SignUpViewModel()
    @EnvironmentObject var appState: AppState
    @State private var firstname = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var showError = false
    
    var onRegisterSuccess: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                SignInUpBackground()
                
                VStack(spacing: 25) {
                    Spacer()
                    Text("signup_welcome_title".localized())
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("signup_welcome_subtitle".localized())
                        .font(.headline)
                        .fontWeight(.regular)
                    
                    Spacer()
                    MailTextField(placeholder: "signup_firstname_placeholder".localized(), text: $firstname)
                    MailTextField(placeholder: "signup_surname_placeholder".localized(), text: $surname)
                    MailTextField(placeholder: "signup_email_placeholder".localized(), text: $email)
                    PasswordTextField(placeholder: "signup_password_placeholder".localized(), text: $password)
                    PasswordTextField(placeholder: "signup_password_confirm_placeholder".localized(), text: $passwordConfirm)
                    
                    Spacer()
                    
                    Button(action: {
                        if validateInputs() {
                            let requestBody = SignUpRequestBody(
                                firstname: firstname,
                                surname: surname,
                                email: email,
                                password: password,
                                passwordConfirm: passwordConfirm
                            )
                            viewModel.register(with: requestBody)
                        }
                    }) {
                        Text("signup_button".localized())
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 50)
                            .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                    }
                    .disabled(!validateInputs())
                    
                    HStack {
                        Text("signup_already_account".localized())
                        NavigationLink {
                            LoginView(onLoginSuccess: onRegisterSuccess)
                        } label: {
                            Text("signin_button".localized())
                                .foregroundStyle(Color("buttonBackgroundColor"))
                        }
                    }
                }.padding()
                    .onChange(of: viewModel.isRegistered) { registered in
                        if registered {
                            appState.isLoggedIn = true
                            onRegisterSuccess()
                        }
                    }
                    .onChange(of: viewModel.errorMessage) { error in
                        if error != nil {
                            showError = true
                        }
                    }
                    .alert(isPresented: $showError) {
                        Alert(
                            title: Text("signup_error_title".localized()),
                            message: Text(viewModel.errorMessage ?? "signup_unknown_error".localized()),
                            dismissButton: .default(Text("signup_alert_ok".localized()))
                        )
                    }
            }
        }
    }
    
    private func validateInputs() -> Bool {
        return !firstname.isEmpty && !surname.isEmpty &&
               !email.isEmpty && !password.isEmpty &&
               password == passwordConfirm
    }
}

#Preview {
    SignUpView {
        print("Registration successful!")
    }
}

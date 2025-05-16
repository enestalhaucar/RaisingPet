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
    @Environment(\.dismiss) var dismiss
    @State private var firstname = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var showError = false
    
    // Focus state değişkenleri
    @FocusState private var firstnameFocused: Bool
    @FocusState private var surnameFocused: Bool
    @FocusState private var emailFocused: Bool
    @FocusState private var passwordFocused: Bool
    @FocusState private var passwordConfirmFocused: Bool
    
    var onRegisterSuccess: () -> Void
    
    var body: some View {
        NavigationStack {
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
                    Text("signup_welcome_title".localized())
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("signup_welcome_subtitle".localized())
                        .font(.headline)
                        .fontWeight(.regular)
                    
                    Spacer()
                    MailTextField(placeholder: "signup_firstname_placeholder".localized(), text: $firstname)
                        .focused($firstnameFocused)
                        .submitLabel(.next)
                        .onSubmit {
                            surnameFocused = true
                        }
                    MailTextField(placeholder: "signup_surname_placeholder".localized(), text: $surname)
                        .focused($surnameFocused)
                        .submitLabel(.next)
                        .onSubmit {
                            emailFocused = true
                        }
                    VStack(alignment: .leading, spacing: 4) {
                        MailTextField(placeholder: "signup_email_placeholder".localized(), text: $email)
                            .focused($emailFocused)
                            .submitLabel(.next)
                            .onSubmit {
                                passwordFocused = true
                            }
                        if !email.isEmpty && !ValidationUtility.isValidEmail(email) {
                            Text("email_format_error_message".localized())
                                .font(.caption2) // Çok küçük yazı
                                .foregroundColor(.red.opacity(0.8))
                                .padding(.leading, 10)
                        }
                    }
                    PasswordTextField(placeholder: "signup_password_placeholder".localized(), text: $password)
                        .focused($passwordFocused)
                        .submitLabel(.next)
                        .onSubmit {
                            passwordConfirmFocused = true
                        }
                    PasswordTextField(placeholder: "signup_password_confirm_placeholder".localized(), text: $passwordConfirm)
                        .focused($passwordConfirmFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            hideKeyboard()
                            if validateInputs() {
                                viewModel.register(
                                    firstName: firstname,
                                    lastName: surname,
                                    email: email,
                                    password: password,
                                    passwordConfirm: passwordConfirm
                                )
                            }
                        }
                    
                    Spacer()
                    
                    Button(action: {
                        hideKeyboard()
                        if validateInputs() {
                            viewModel.register(
                                firstName: firstname,
                                lastName: surname,
                                email: email,
                                password: password,
                                passwordConfirm: passwordConfirm
                            )
                        }
                    }) {
                        Text("signup_button".localized())
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 50)
                            .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                    }
                    .disabled(!validateInputs())
                    .opacity(validateInputs() ? 1.0 : 0.5)
                    
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("signup_already_account".localized())
                                .foregroundStyle(Color("buttonBackgroundColor"))
                        }
                    }
                }
                .padding()
                .onChange(of: viewModel.isRegistered) { _, registered in
                    if registered {
                        appState.isLoggedIn = true
                        onRegisterSuccess()
                    }
                }
                .onChange(of: viewModel.errorMessage) { _, error in
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
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // Klavyeyi gizleme fonksiyonu
    private func hideKeyboard() {
        firstnameFocused = false
        surnameFocused = false
        emailFocused = false
        passwordFocused = false
        passwordConfirmFocused = false
    }
    
    private func validateInputs() -> Bool {
        return !firstname.isEmpty && !surname.isEmpty &&
               !email.isEmpty && ValidationUtility.isValidEmail(email) &&
               !password.isEmpty && ValidationUtility.isValidPassword(password) &&
               password == passwordConfirm
    }
}

#Preview {
    SignUpView {
        print("Registration successful!")
    }
}

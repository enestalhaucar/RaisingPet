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
                        Text("Sign Up")
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 50)
                            .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                    }
                    .disabled(!validateInputs())
                    
                    
                    
                    
                    
                    HStack {
                        Text("Already have an account ?")
                        NavigationLink {
                            LoginView(onLoginSuccess: onRegisterSuccess)
                        } label: {
                            Text("Sign In")
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
                            title: Text("Registration Error"),
                            message: Text(viewModel.errorMessage ?? "Unknown error"),
                            dismissButton: .default(Text("OK"))
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

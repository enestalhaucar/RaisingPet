//
//  SignInView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI
import Combine

struct LoginView: View {
    @StateObject var loginViewModel : LoginViewModel
    @ObservedObject var appViewModel : AppViewModel
    @State private var email = "omerdmn1@hotmail.com"
    @State private var password = "Renekton1"
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(appViewModel: appViewModel))
    }
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
                        loginViewModel.login(email: email, password: password) 
                        
                    } label: {
                        Text("Sign In")
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 50)
                            .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                        
                    }
                    
                    HStack {
                        Text("Don't you have an account ?")
                        NavigationLink {
                            SignUpView(appViewModel: appViewModel)
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
    LoginView(appViewModel: AppViewModel())
}

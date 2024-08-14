//
//  SignInView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI

@MainActor
final class SignInViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    func signIn() async throws{
        guard !email.isEmpty, !password.isEmpty else {
            print("No mail or password")
            return
        }
        
        try await AuthenticationManager.shared.signIn(email: email, password: password)
        print("success signIn")
    }
}

struct SignInView: View {
    @State var email : String = ""
    @State var password : String = ""
    @StateObject private var viewModel = SignInViewModel()
    @Binding var isSuccess : Bool
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
                    CustomTextField(placeholder: "Enter your email", text: $email)
                    CustomTextField(placeholder: "Enter your password", text: $password)
                    
                    NavigationLink {
                        
                    } label: {
                        Text("Forgot Password")
                            .foregroundStyle(Color("buttonBackgroundColor"))
                            .font(.headline)
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.signIn()
                                isSuccess = false
                            } catch {
                                print("error while signUp from signupview")
                            }
                        }
                    } label: {
                        Text("Sign In")
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 50)
                            .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                        
                    }
                    
                    HStack {
                        Text("Don't you have an account ?")
                        NavigationLink {
                            SignUpView(isSuccess: $isSuccess)
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
    SignInView(isSuccess: .constant(false))
}

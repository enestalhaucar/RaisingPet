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
    @Published var fullName = ""
    
    
    func signUp() async throws{
        guard !email.isEmpty, !password.isEmpty else {
            print("No mail or password")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        print("success")
    }
    
    func signInGoogle() async throws {
        let helper = GoogleSignInHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
}


struct SignUpView: View {
    @State var email : String = ""
    @State var password : String = ""
    @State var repassword : String = ""
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
                    
                    CustomTextField(placeholder: "Enter your name", text: $viewModel.fullName)
                    CustomTextField(placeholder: "Enter your email", text: $viewModel.email)
                    CustomTextField(placeholder: "Enter your password", text: $viewModel.password)
                    
                    
                    
                    
                    Spacer()
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.signUp()
                                isSuccess = false
                            } catch {
                                print("error while signUp from signupview")
                            }
                        }
                    }, label: {
                        Text("Sign Up")
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 50)
                            .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                    })
                    
                  
                    
                    HStack(spacing: 15) {
                        GoogleSignInButton(scheme: .light, style: .icon, state: .normal) {
                            Task {
                                do {
                                    try await viewModel.signInGoogle()
                                    isSuccess = false
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

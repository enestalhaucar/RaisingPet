//
//  RegisterView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI


@MainActor
final class SignUpViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullName = ""
    
    func signUp() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No mail or password")
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Failure")
            }
        }
    }
}


struct SignUpView: View {
    @State var email : String = ""
    @State var password : String = ""
    @State var repassword : String = ""
    @StateObject private var viewModel = SignUpViewModel()
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
                        viewModel.signUp()
                    }, label: {
                        Text("Sign Up")
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 50)
                            .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
                    })
                    
                    HStack(spacing: 15) {
                        Image("Google")
                        Image("Apple")
                        Image("Facebook")
                            
                    }
                    HStack {
                        Text("Already have an account ?")
                        NavigationLink {
                            SignInView()
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
    SignUpView()
}

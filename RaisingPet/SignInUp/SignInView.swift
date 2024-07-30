//
//  SignInView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI

@MainActor
final class SignInViewModel : ObservableObject {
    @Published var email : String = ""
}

struct SignInView: View {
    @State var email : String = ""
    @State var password : String = ""
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
                    button(title: "Sign In")
                    HStack {
                        Text("Don't you have an account ?")
                        NavigationLink {
                            SignUpView()
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
    SignInView()
}

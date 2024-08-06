//
//  AuthenticationManager.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 30.07.2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid : String
    let email : String?
    let photoUrl : String?
    
    init(user : User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }
    
    // MARK: Get Authendicated User
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        return AuthDataResultModel(user: user)
    }
    
    
    // MARK: Sign Out from App
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}


// Sign in With Email
extension AuthenticationManager {
    // MARK: Firebase Create User w/ Email/Password
    @discardableResult
    func createUser(email : String, password : String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
    
    
    // MARK: Sign In
    @discardableResult
    func signIn(email : String, password : String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
}
// Sign In With Google
extension AuthenticationManager {
    @discardableResult
    func signInWithGoogle(tokens : GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    func signIn(credential : AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

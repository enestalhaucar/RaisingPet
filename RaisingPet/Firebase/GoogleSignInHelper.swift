//
//  GoogleSignInHelper.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 5.08.2024.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken : String
    let accessToken : String
}

final class GoogleSignInHelper {
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.topViewController() else {
            throw URLError(.badURL)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken : String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badURL)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        return tokens
    }
    
    
    
    
}

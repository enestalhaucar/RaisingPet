//
//  LoginRequestModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

// MARK: Sign Up Request Body
struct SignUpRequestBody: Codable {
    let firstname: String
    let surname: String
    let email: String
    let password: String
    let passwordConfirm: String
}

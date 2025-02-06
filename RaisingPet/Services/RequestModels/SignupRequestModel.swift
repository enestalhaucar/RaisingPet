//
//  SignupModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 10.12.2024.
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


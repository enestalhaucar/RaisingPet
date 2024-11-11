//
//  JWTService.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 5.11.2024.
//

import Foundation

enum AuthenticationError : Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

struct LoginRequestBody : Codable {
    let email : String
    let password : String
}

struct LoginResponse: Codable {
    let status: String
    let token: String
    let data: UserData
}

struct UserData: Codable {
    let user: User
}


struct User: Codable {
    let _id: String
    let firstname: String
    let surname: String
    let email: String
    let photo: String
    let role: String
    let pets: [String]
    let gameCurrency: Int
}


struct SignUpRequestBody: Codable {
    let firstname: String
    let surname: String
    let email: String
    let password: String
    let passwordConfirm: String
}

struct SignUpResponseBody : Codable {
    let status: String
    let token: String
    let data: UserData
}



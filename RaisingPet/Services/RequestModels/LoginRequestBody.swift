//
//  LoginRequestBody.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 24.01.2025.
//


// MARK: Login Request
struct LoginRequestBody : Codable {
    let email : String
    let password : String
}
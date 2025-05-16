//
//  LoginRequestModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

// MARK: Login Request
struct LoginRequestBody : Codable {
    let email : String
    let password : String
}

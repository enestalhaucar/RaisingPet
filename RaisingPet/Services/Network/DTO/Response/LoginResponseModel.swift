//
//  LoginResponseModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

// MARK: - Login Response Model
struct LoginResponseModel: Codable {
    let status: String
    let token: String
    let data: UserData
}

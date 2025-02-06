//
//  LoginModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 10.12.2024.
//


import Foundation
import Alamofire


// MARK: Login Response
struct LoginResponse: Codable {
    let status: String
    let token: String
    let data: UserData
}

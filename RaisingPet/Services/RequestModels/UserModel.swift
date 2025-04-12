//
//  JWTService.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 5.11.2024.
//

import Foundation

// MARK: User Model
struct User: Codable {
    let _id: String?
    let firstname: String?
    let surname: String?
    let email: String?
    let photo: String?
    let role: String?
    let isDeleted : Bool?
    let gameCurrencyGold: Int?
    let gameCurrencyDiamond: Int?
    let pets: [String]?
    let friendTag : String?
    let __v: Int
}

struct UserData: Codable {
    let user: User
}






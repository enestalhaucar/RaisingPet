//
//  GetMeResponseModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

// MARK: - GetMe Response Model
struct GetMeResponseModel: Codable {
    let status: String
    let data: GetMeUser?
}

struct GetMeUser: Codable {
    let id: String
    let firstname: String
    let surname: String
    let email: String
    let photo: String?
    let role: String
    let gameCurrencyGold: Int
    let gameCurrencyDiamond: Int
    let isDeleted: Bool
    let friendTag: String
    let version: Int
    let phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case id                 = "_id"
        case firstname, surname, email, photo, role
        case gameCurrencyGold, gameCurrencyDiamond, isDeleted, friendTag, phoneNumber
        case version            = "__v"
    }
}

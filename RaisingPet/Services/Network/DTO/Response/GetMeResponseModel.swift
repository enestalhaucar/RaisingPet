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
    let data: DataWrapper?
    
    struct DataWrapper: Codable {
        let data: GetMeUser?
    }
}

struct GetMeUser: Codable, Identifiable {
    let id: String
    let firstname: String
    let surname: String
    let email: String
    let photo: String?
    let photoURL: String?
    let role: String
    let gameCurrencyGold: Int
    let gameCurrencyDiamond: Int
    let isDeleted: Bool
    let friendTag: String
    let version: Int
    let phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case id, firstname, surname, email, photo, role, photoURL
        case gameCurrencyGold, gameCurrencyDiamond, isDeleted, friendTag, phoneNumber
        case version = "__v"
        case _id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to decode id from multiple possible fields
        if let mainId = try? container.decode(String.self, forKey: .id) {
            id = mainId
        } else if let backupId = try? container.decode(String.self, forKey: ._id) {
            id = backupId
        } else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Neither 'id' nor '_id' found")
        }
        
        // Required fields
        firstname = try container.decode(String.self, forKey: .firstname)
        surname = try container.decode(String.self, forKey: .surname)
        email = try container.decode(String.self, forKey: .email)
        
        // Optional fields with safe fallbacks
        photo = try container.decodeIfPresent(String.self, forKey: .photo)
        photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        role = try container.decodeIfPresent(String.self, forKey: .role) ?? "user"
        gameCurrencyGold = try container.decodeIfPresent(Int.self, forKey: .gameCurrencyGold) ?? 0
        gameCurrencyDiamond = try container.decodeIfPresent(Int.self, forKey: .gameCurrencyDiamond) ?? 0
        isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        friendTag = try container.decodeIfPresent(String.self, forKey: .friendTag) ?? ""
        version = try container.decodeIfPresent(Int.self, forKey: .version) ?? 0
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(firstname, forKey: .firstname)
        try container.encode(surname, forKey: .surname)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(photo, forKey: .photo)
        try container.encodeIfPresent(photoURL, forKey: .photoURL)
        try container.encode(role, forKey: .role)
        try container.encode(gameCurrencyGold, forKey: .gameCurrencyGold)
        try container.encode(gameCurrencyDiamond, forKey: .gameCurrencyDiamond)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(friendTag, forKey: .friendTag)
        try container.encode(version, forKey: .version)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
    }
}

//
//  PetsModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

// MARK: - Pet
struct Pet: Codable, Identifiable {
    let id: String
    let ownerId: String
    let petType: PetType
    let hunger: Int
    let thirst: Int
    let hygiene: Int
    let fun: Int
    let isHatched: Bool
    let isDeleted: Bool
    let petHistory: PetHistory
    let version: Int
    let hatchedAt: String
    let nextBarUpdate: String
    let isHatchedByThisEgg: Bool? // Sadece HatchPetsResponse için, opsiyonel

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ownerId, petType, hunger, thirst, hygiene, fun
        case isHatched, isDeleted, petHistory
        case version = "__v"
        case hatchedAt, nextBarUpdate, isHatchedByThisEgg
    }
}

// MARK: - Pet Type
struct PetType: Codable {
    let id: String
    let rarity: Rarity
    let name: String
    let isDeleted: Bool
    let version: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rarity, name, isDeleted
        case version = "__v"
    }
}

// MARK: - Rarity
struct Rarity: Codable {
    let id: String
    let rarityName: String
    let weight: Int
    let isDeleted: Bool
    let version: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rarityName, weight, isDeleted
        case version = "__v"
    }
}

// MARK: - Pet History
struct PetHistory: Codable {
    let id: String
    let petId: String
    let actions: [Action]
    let isDeleted: Bool
    let version: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case petId, actions, isDeleted
        case version = "__v"
    }
}

// MARK: - Action
struct Action: Codable {
    let id: String
    let actionType: String
    let performedBy: String
    let madeAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case actionType, performedBy, madeAt
    }
}

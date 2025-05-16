//
//  GetInventoryResponseModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

// MARK: - Get Inventory Response Model
struct GetInventoryResponseModel: Codable {
    let status: String
    let data: InventoryData
}

// MARK: - Inventory Data Wrapper
struct InventoryData: Codable {
    let inventory: Inventory
}

// MARK: - Inventory
struct Inventory: Codable {
    let id: String
    let userId: String
    let items: [InventoryItem]
    let isDeleted: Bool
    let version: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, items, isDeleted
        case version = "__v"
    }
}

// MARK: - Inventory Item
struct InventoryItem: Codable, Identifiable {
    let id: String?
    let itemType: ItemType
    let itemId: ItemDetail
    let acquiredAt: String?
    let properties: ItemProperties

    var isPetItem: Bool { itemType == .petItem }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case itemType, itemId, acquiredAt, properties
    }
}

// MARK: - Item Type
enum ItemType: String, Codable {
    case shopItem = "ShopItem"
    case petItem = "PetItem"
}

// MARK: - Item Detail
struct ItemDetail: Codable {
    let id: String
    let name: String
    let description: String?
    let category: String?
    let isDeleted: Bool
    let version: Int
    let effectAmount: Int? // PetItem için
    let effectType: EffectType? // PetItem için
    let barAffected: BarAffected? // PetItem için
    let diamondPrice: Int? // PetItem için
    let goldPrice: Int? // PetItem için
    let currencyType: CurrencyType? // PetItem için
    let idAlias: String? // ShopItem (home) için

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, description, category, isDeleted
        case version = "__v"
        case effectAmount, effectType, barAffected
        case diamondPrice, goldPrice, currencyType
        case idAlias = "id"
    }
}

// MARK: - Item Properties
struct ItemProperties: Codable {
    let egg: EggProperties?
    let quantity: Int?
    let isOwned: Bool?

    struct EggProperties: Codable {
        let crackedAt: String
        let whichEgg: String
        let eggPackageId: String?
        let whichPetDidItComeFrom: String?
        let isCrackedByUser: Bool
    }
}

// MARK: - Enums
enum EffectType: String, Codable {
    case funMaterial
    case edibleMaterial
    case drinkableMaterial
    case cleaningMaterial
}

enum BarAffected: String, Codable {
    case hunger
    case thirst
    case hygiene
    case fun
}

enum CurrencyType: String, Codable {
    case both
}

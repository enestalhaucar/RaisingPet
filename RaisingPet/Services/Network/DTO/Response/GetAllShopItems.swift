//
//  GetAllShopItems.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

// MARK: - GetAllShopItems
struct GetAllShopItems: Codable {
    let status: String?
    let data: AllItems
}

// MARK: - AllItems
struct AllItems: Codable {
    let shopItems: [ShopItem]
    let petItems: [PetItem]
    let petPackages: [PetPackage]
    let eggPackages: [EggPackage]
    let petItemPackages: [PetItemPackage]
}

// MARK: - ShopItem
struct ShopItem: Codable, Identifiable {
    let id: String?
    let name: String?
    let description: String?
    let category: ShopItemCategory?
    let isDeleted: Bool?
    let v: Int?
    let duration: Int?
    let isPurchasable: Bool?
    let diamondPrice: Int?
    let goldPrice: Int?
    let quantity: Int?
    let price: Int?
    let isOwned: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case category
        case isDeleted
        case v = "__v"
        case duration
        case isPurchasable
        case diamondPrice
        case goldPrice
        case quantity
        case price
        case isOwned
    }
}

// MARK: - PetItem
struct PetItem: Codable {
    let id: String?
    let name: String?
    let description: String?
    let effectAmount: Int?
    let effectType: String?
    let barAffected: String?
    let diamondPrice: Int?
    let currencyType: PetItemCategory?
    let isDeleted: Bool?
    let v: Int?
    let goldPrice: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case effectAmount
        case effectType
        case barAffected
        case diamondPrice
        case currencyType
        case isDeleted
        case v = "__v"
        case goldPrice
    }
}

// MARK: - ShopItemCategory Enum
enum ShopItemCategory: String, Codable {
    case eggs = "eggs"
    case gameCurrencyDiamond = "gameCurrencyDiamond"
    case home = "home"
}

// MARK: - PetItemCategory Enum
enum PetItemCategory: String, Codable {
    case both = "both"
    case onlyDiamond = "onlyDiamond"
}

// MARK: - PetPackage
struct PetPackage: Codable {
    let id: String?
    let name: String?
    let description: String?
    let petItemTypes: [PetItemType]?
    let limit: Int?
    let isDeleted: Bool?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case petItemTypes
        case limit
        case isDeleted
        case v = "__v"
    }
}

// MARK: - EggPackage
struct EggPackage: Codable {
    let id: String?
    let name: String?
    let description: String?
    let eggType: EggType?
    let amount: Int?
    let currencyType: String?
    let isDeleted: Bool?
    let diamondPrice: Int?
    let v: Int?
    let isPurchasable: Bool?
    let goldPrice: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case eggType
        case amount
        case currencyType
        case isDeleted
        case diamondPrice
        case v = "__v"
        case isPurchasable
        case goldPrice
    }
}

// MARK: - EggType
struct EggType: Codable {
    let id: String?
    let shopItemId: String?
    let duration: Int?
    let buffEffect: Int?
    let whichEgg: String?
    let diamondPrice: Int?
    let currencyType: String?
    let isDeleted: Bool?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case shopItemId
        case duration
        case buffEffect
        case whichEgg
        case diamondPrice
        case currencyType
        case isDeleted
        case v = "__v"
    }
}

// MARK: - PetItemPackage
struct PetItemPackage: Codable, Identifiable {
    let id: String?
    let name: String?
    let description: String?
    let petItemTypes: [PetItemType]?
    let limit: Int?
    let isDeleted: Bool?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case petItemTypes
        case limit
        case isDeleted
        case v = "__v"
    }
}

// MARK: - Extensions

extension PetItemPackage {
    func toShopItem() -> ShopItem {
        ShopItem(
            id: id,
            name: name,
            description: description,
            category: .home,
            isDeleted: isDeleted,
            v: v,
            duration: nil,
            isPurchasable: true,
            diamondPrice: nil,
            goldPrice: nil,
            quantity: limit,
            price: nil,
            isOwned: false
        )
    }
}

extension PetItem {
    func toShopItem() -> ShopItem {
        ShopItem(
            id: id,
            name: name,
            description: description,
            category: .home,
            isDeleted: isDeleted,
            v: v,
            duration: nil,
            isPurchasable: true,
            diamondPrice: diamondPrice,
            goldPrice: goldPrice,
            quantity: nil,
            price: nil,
            isOwned: false
        )
    }
}

// MARK: - PetItemType
struct PetItemType: Codable {
    let id: String?
    let name: String?
    let description: String?
    let effectAmount: Int?
    let effectType: String?
    let barAffected: String?
    let diamondPrice: Int?
    let currencyType: String?
    let isDeleted: Bool?
    let goldPrice: Int?
    let _id: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case effectAmount
        case effectType
        case barAffected
        case diamondPrice
        case currencyType
        case isDeleted
        case goldPrice
        case _id = "_id"
        case v = "__v"
    }
}

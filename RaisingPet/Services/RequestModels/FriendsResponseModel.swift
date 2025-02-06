//
//  FriendsModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 10.12.2024.
//

import Foundation

// MARK: - Friends Response Model
struct FriendResponse: Codable {
    let status: String
    let data: FriendData
}

struct FriendData: Codable {
    let friends: [Friend]
}

struct Friend: Codable {
    let _id: String
    let status: FriendStatus
    let createdAt: String
    let updatedAt: String
    let __v: Int
    let friend: FriendDetails
}

struct FriendDetails: Codable {
    let _id: String
    let firstname: String
    let surname: String
}

// MARK: - Friend Status Enum
enum FriendStatus: String, Codable {
    case accepted
    case rejected
    case pending
}

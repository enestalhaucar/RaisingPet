//
//  FriendsModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 10.12.2024.
//

import Foundation

// MARK: Friends Response Model
struct FriendResponse: Codable {
    let status: String
    let data: FriendData
}

struct FriendData: Codable {
    let friends: [Friend]
}

struct Friend: Codable {
    let _id: String
    let userId: String
    let friendId: FriendDetails
    let status: String
    let createdAt: String
    let updatedAt: String
    let __v: Int
}

struct FriendDetails: Codable {
    let _id: String
    let firstname: String
    let surname: String
    let friendTag: String
}

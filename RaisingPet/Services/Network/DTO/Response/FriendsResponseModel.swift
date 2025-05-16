//
//  FriendsResponseModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

struct FriendsResponseModel: Codable {
    let status: String
    let data: FriendResponseData
}

struct FriendResponseData: Codable {
    let friends: [Friend]
}

struct Friend: Codable, Identifiable {
    let id: String
    let status: String
    let isDeleted: Bool
    let createdAt: String
    let updatedAt: String
    let __v: Int
    let friend: FriendDetail

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case isDeleted
        case createdAt
        case updatedAt
        case __v
        case friend
    }
}

struct FriendDetail: Codable {
    let _id: String
    let firstname: String
    let surname: String
    let friendTag: String
    let isSending: Bool
}

struct FriendRequestResponse: Codable {
    let status: String
    let data: FriendRequestData
}

struct FriendRequestData: Codable {
    let friendRequest: FriendRequest
}

struct FriendRequest: Codable {
    let _id: String
    let userId: String
    let friendId: String
    let status: String
    let isDeleted: Bool
    let createdAt: String
    let updatedAt: String
    let __v: Int
}

struct SearchFriendWithTagResponse: Codable {
    let status: String
    let data: SearchFriendWithTagData
}

struct SearchFriendWithTagData: Codable {
    let user: SearchFriendWithTagDataUser?
}

struct SearchFriendWithTagDataUser: Codable {
    let id: String
    let firstname: String
    let surname: String
    let email: String
    let photo: String
    let role: String
    let gameCurrencyGold: Int
    let gameCurrencyDiamond: Int
    let friendTag: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstname
        case surname
        case email
        case photo
        case role
        case gameCurrencyGold
        case gameCurrencyDiamond
        case friendTag
        case v = "__v"
    }
}

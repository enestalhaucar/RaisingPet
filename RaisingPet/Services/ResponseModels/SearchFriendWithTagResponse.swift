//
//  SearchFriendWithTagResponse.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.03.2025.
//

import Foundation

struct SearchFriendWithTagResponse : Codable {
    let status : String
    let data : SearchFriendWithTagData
}

struct SearchFriendWithTagData : Codable {
    let user : SearchFriendWithTagDataUser
}

struct SearchFriendWithTagDataUser : Codable {
    let id : String
    let firstname : String
    let surname : String
    let email : String
    let photo : String
    let role : String
    let gameCurrency : Int
    let friendTag : String
    let v : Int
    
    enum CodingKeys : String, CodingKey {
        case id = "_id"
        case firstname
        case surname
        case email
        case photo
        case role
        case gameCurrency
        case friendTag
        case v = "__v"
    }
}

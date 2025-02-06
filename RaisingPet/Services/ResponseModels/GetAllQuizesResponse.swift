//
//  GetAllQuizesResponse.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 4.02.2025.
//

import Foundation

struct GetAllQuizesResponseModel: Codable {
    let status: String
    let results: Int
    let data: QuizListModel
}

struct QuizListModel: Codable {
    let data: [QuizModel]
}

struct QuizModel: Codable {
    let id: String
    let title: String
    let questions: [String]
    let isDeleted: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case questions
        case isDeleted
        case createdAt
    }
}

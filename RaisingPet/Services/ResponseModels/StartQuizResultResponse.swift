//
//  StartQuizResultResponse.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.02.2025.
//

import Foundation

struct StartQuizResultResponse : Codable {
    let status: String
    let data: QuizResultData
}

struct QuizResultData: Codable {
    let quizResult: QuizResult
}

struct QuizResult: Codable {
    let quizId: String
    let user1: String
    let user2: String
    let answers: [String]
    let status: String
    let id: String
    let createdAt: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case quizId = "quizId"
        case user1
        case user2
        case answers
        case status
        case id = "_id" 
        case createdAt
        case v = "__v"
    }
}

//
//  TakeQuizResponse.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.02.2025.
//

import Foundation

struct TakeQuizResponse : Codable {
    let status: String?
    let data: QuizResultData?
}

struct QuizResultData: Codable {
    let quizId: QuizDetail?
    let user1: String?
    let user2: String?
    let answers: [AnswerModel]?
    let status: String?
    let flagUser1EverDone: Bool?
    let flagUser2EverDone: Bool?
    let id: String?
    let createdAt: String?
    let v : Int?
    
    enum CodingKeys: String, CodingKey {
        case quizId
        case user1
        case user2
        case answers
        case status
        case flagUser1EverDone
        case flagUser2EverDone
        case id = "_id"
        case createdAt
        case v = "__v"
    }
}

struct QuizDetail: Codable {
    let id: String
    let title: String
    let category: String
    let createdAt: String
    let questions: [QuestionModel]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case category
        case createdAt
        case questions
    }
}

struct AnswerModel: Codable {
    let question: String
    let user1Answer: String?
    let user2Answer: String?
    let isMatched: Bool?
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case question
        case user1Answer
        case user2Answer
        case isMatched
        case id = "_id"
    }
}


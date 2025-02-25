//
//  TakeQuizResponse.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.02.2025.
//

import Foundation

struct QuizResponse: Codable {
    let status: String
    let data: QuizData
}

struct QuizData: Codable {
    let _id: String
    let quizId: QuizInfo
    let user1: String
    let user2: String
    let answers: [QuizAnswerResponse]
    let status: String
    let createdAt: String
    let __v: Int
}

struct QuizInfo: Codable {
    let _id: String
    let title: String
    let category: String
    let createdAt: String
    let __v: Int
    let questions: [Question]
}

struct Question: Codable {
    let _id: String
    let order: Int
    let options: [String]
    let quiz: String
    let __v: Int
}

struct QuizAnswerResponse: Codable {
    let question: String
    let user1Answer: String
    let user2Answer: String?
    let isMatched: Bool?
    let _id: String
}



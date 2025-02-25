//
//  QuizResultForQuizResponse.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.02.2025.
//

import Foundation

struct QuizResultForQuizResponse: Codable {
    let status : String
    let data : QuizResultForQuizData
}

struct QuizResultForQuizData : Codable {
    let formattedQuizResult: QuizResultForQuizResponseFormattedQuizResult
}

struct QuizResultForQuizResponseFormattedQuizResult: Codable {
    let quizId: String
    let user: String
    let friend: String
    let answers: [QuizAnswer]
    let status: String
    let createdAt: String
}

struct QuizResultForQuizAnswer: Codable {
    let question: String
    let userAnswer: String
    let friendAnswer: String?
    let isMatched: Bool?
}

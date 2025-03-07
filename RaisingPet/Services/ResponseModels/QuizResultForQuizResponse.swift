//
//  QuizResultForQuizResponse.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.02.2025.
//

import Foundation

struct QuizResultForQuizResponse: Codable {
    let status : String?
    let data : QuizResultForQuizData?
}

struct QuizResultForQuizData : Codable {
    let formattedQuizResult: QuizResultForQuizResponseFormattedQuizResult?
}

struct QuizResultForQuizResponseFormattedQuizResult: Codable {
    let quizId: String?
    let user: String?
    let friend: String?
    let answers: [QuizResultForQuizAnswer]?
    let status: String?
    let createdAt: String?
}

struct QuizResultForQuizAnswer: Codable, Identifiable, Hashable {
    let question: String?
    let userAnswer: String?
    let friendAnswer: String?
    
    var id: String { question ?? UUID().uuidString }
}

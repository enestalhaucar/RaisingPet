//
//  TakeQuizRequest.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.02.2025.
//

import Foundation

struct TakeQuizRequest: Codable {
    let quizId: String
    let preAnswers: [QuizAnswer]
}

struct QuizAnswer: Codable {
    let questionId: String
    let option: String
}

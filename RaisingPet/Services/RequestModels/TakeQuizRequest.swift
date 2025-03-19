//
//  TakeQuizRequest.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.02.2025.
//

import Foundation

struct TakeQuizRequest: Codable {
    let quizId: String?
    let preAnswers: [QuizAnswer]?
    
    enum CodingKeys: String, CodingKey {
        case quizId
        case preAnswers = "pre_answers"
    }
}

struct QuizAnswer: Codable {
    let question: TakeQuizQuestionID
    let option : String
}
struct TakeQuizQuestionID : Codable {
    let _id : String 
    
    
}

//
//  QuestionResponseModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.02.2025.
//

import Foundation

struct GetQuizByIdResponseModel: Codable {
    let status: String
    let data: QuizDataContainer
    
    struct QuizDataContainer: Codable {
        let data: QuizDetailModel 
    }
    
    struct QuizDetailModel: Codable {
        let id: String?
        let category : QuizCategoryModel?
        let createdAt: String?
        let v : Int?
        let title: String?
        let questions: [QuestionModel]?

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case category
            case createdAt
            case v = "__v"
            case title
            case questions
        }
    }
    
    
}




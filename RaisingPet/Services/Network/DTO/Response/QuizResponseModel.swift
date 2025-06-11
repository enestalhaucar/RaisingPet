//
//  QuizResponseModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

// GetQuizByIdResponseModel
struct GetQuizByIdResponseModel: Codable {
    let status: String
    let data: QuizDataContainer
    
    struct QuizDataContainer: Codable {
        let data: QuizDetailModel
    }
    
    struct QuizDetailModel: Codable {
        let id: String?
        let category: QuizCategoryModel?
        let createdAt: String?
        let v: Int?
        let title: String?
        let questions: [QuestionModel]?
        let isDeleted: Bool?

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case category
            case createdAt
            case v = "__v"
            case title
            case questions
            case isDeleted
        }
    }
}

// GetUserQuizes
struct GetUserQuizes: Codable {
    let status: String
    let results: Int
    let data: [QuizModel]
}

struct QuizModel: Codable {
    let id: String?
    let title: String?
    let category: QuizCategoryModel?
    let createdAt: String?
    let questions: [QuestionModel]?
    let v: Int?
    let quizStatus: QuizStatus?
    let accuracy: Double?
    let isDeleted: Bool?
    let userDone: Bool? // Yeni
    let friendDone: Bool? // Yeni

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case category
        case createdAt
        case questions
        case v = "__v"
        case quizStatus
        case accuracy
        case isDeleted
        case userDone
        case friendDone
    }
}

struct QuestionModel: Codable, Identifiable {
    let id: String
    let order: Int
    let options: [String]
    let quizId: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case order
        case options
        case quizId = "quiz"
        case v = "__v"
    }
}

enum QuizCategoryModel: String, Codable {
    case food = "Food"
    case drink = "Drink"
    case movie = "Movie"
    case sport = "Sport"
    case travel = "Travel"
    case music = "Music"
    case tech = "Tech"
    case fashion = "Fashion"
    case pet = "Pet"
    case hobby = "Hobby"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = QuizCategoryModel(rawValue: rawValue) ?? .unknown
    }
}

enum QuizStatus: String, Codable {
    case continued = "continued"
    case finished = "finished"
    case never = "never"
}

// TakeQuizResponse
struct TakeQuizResponse: Codable {
    let status: String
    let data: TakeQuizResponseData
}

struct TakeQuizResponseData: Codable {
    let quizId: GetQuizByIdResponseModel.QuizDetailModel
    let user1: String
    let user2: String
    let answers: [TakeQuizAnswer]
    let status: QuizStatus
    let flagUser1EverDone: Bool
    let flagUser2EverDone: Bool
    let isDeleted: Bool
    let id: String
    let createdAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case quizId
        case user1
        case user2
        case answers
        case status
        case flagUser1EverDone
        case flagUser2EverDone
        case isDeleted
        case id = "_id"
        case createdAt
        case v = "__v"
    }
}

struct TakeQuizAnswer: Codable {
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

// QuizResultForQuizResponse
struct QuizResultForQuizResponse: Codable {
    let status: String?
    let data: QuizResultForQuizData?
}

struct QuizResultForQuizData: Codable {
    let formattedQuizResult: QuizResultForQuizResponseFormattedQuizResult?
}

struct QuizResultForQuizResponseFormattedQuizResult: Codable {
    let quizId: String?
    let user: String?
    let friend: String?
    let answers: [QuizResultForQuizAnswer]?
    let status: QuizStatus?
    let createdAt: String?
    let accuracy: Double?
}

struct QuizResultForQuizAnswer: Codable, Identifiable, Hashable {
    let question: String?
    let userAnswer: String?
    let friendAnswer: String?
    let isMatched : Bool?
    
    var id: String { question ?? UUID().uuidString }
}

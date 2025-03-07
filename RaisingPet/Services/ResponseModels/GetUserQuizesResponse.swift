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
    let data: [QuizModel]
}

struct QuizModel: Codable {
    let id: String?
    let title: String?
    let category: QuizCategoryModel?
    let createdAt : String?
    let questions : [QuestionModel]?
    let v : Int?
    let quizStatus : QuizStatus?
    let accuracy : Double?
    
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case title
            case category
            case createdAt
            case questions
            case v = "__v"
            case quizStatus
            case accuracy
        }
}

struct QuestionModel: Codable, Identifiable {
    let id: String
    let order: Int
    let options: [String]
    let quizId : String
    let v : Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case order
        case options
        case quizId = "quiz"
        case v = "__v"
    }
}

/*
 Kategoriler ve Quizler
 Food (Food 1, Food 2)
 Drinks (Drinks 1, Drinks 2)
 Movies (Movies 1, Movies 2)
 Sports (Sports 1, Sports 2)
 Travel (Travel 1, Travel 2)
 Music (Music 1, Music 2)
 Tech (Tech 1, Tech 2)
 Fashion (Fashion 1, Fashion 2)
 Pets (Pets 1, Pets 2)
 Hobbies (Hobbies 1, Hobbies 2)
 */

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
    // Eğer API'den gelen kategori bilinmiyorsa default
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = QuizCategoryModel(rawValue: rawValue) ?? .unknown
    }
}
enum QuizStatus : String, Codable {
    case continued = "continued"
    case finished = "finished"
    case never = "never"
}

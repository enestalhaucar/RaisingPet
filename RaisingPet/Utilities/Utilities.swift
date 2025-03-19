//
//  Utilities.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 4.08.2024.
//

import Foundation
import UIKit

final class Utilities {
    static let shared = Utilities()
    private init() {}
    
    struct Constants {
        static let baseURL = "http://3.74.213.54:3000/api/v1"
        
        // Screen Size
        static let width = UIScreen.main.bounds.width
        static let height = UIScreen.main.bounds.height
        static let widthHalf: CGFloat = .init(width / 2)
        static let widthQuarter: CGFloat = .init(width / 4)
        static let heightHalf: CGFloat = .init(height / 2)
        static let widthWithoutEdge : CGFloat = .init(width - 24)
        static let widthEight: CGFloat = .init(width * 8 / 10)
        static let widthFour: CGFloat = .init(width * 4 / 10)
        static let heightFour: CGFloat = .init(height * 4 / 10)
        
        struct Endpoints {
            // Auth Endpoints
            struct Auth {
                static let login = "\(baseURL)/users/login"
                static let signup = "\(baseURL)/users/signup"
            }
            
            // Friends Endpoints
            struct Friends {
                static let searchFriendWithTag = "\(baseURL)/friends/search"
                static let sendRequest = "\(baseURL)/friends/send-request"
                static let acceptRequest = "\(baseURL)/friends/accept-request"
                static let rejectRequest = "\(baseURL)/friends/reject-request"
                static let list = "\(baseURL)/friends/list"
            }
            
            // Pets Endpoints
            struct Pets {
                static let myPets = "\(baseURL)/pets/my-pets"
                static let petItems = "\(baseURL)/pets/pet-items"
                static let petItemInteraction = "\(baseURL)/pets/pet-item-interaction"
                static let petCareInteraction = "\(baseURL)/pets/pet-care-interaction"
            }
            
            // Shop Endpoints
            struct Shop {
                static let base = "\(baseURL)/shop/"
                static let buyItem = "\(baseURL)/shop/buy-item"
                static let shopDetails = "\(baseURL)/shop"
            }
            
            // Inventory Endpoints
            struct Inventory {
                static let myInventory = "\(baseURL)/inventory/my-inventory"
            }
            
            // Quiz
            
            struct Quiz {
                static let getQuizById = "\(baseURL)/quiz/:id"
                static let getUserQuizes = "\(baseURL)/quiz/myQuizzes"
                static let takeQuiz = "\(baseURL)/quiz/takeQuiz"
                static let quizResultForQuiz = "\(baseURL)/quiz/getQuizResultForQuiz"
            }
        }
    }
    
    func getUserDetailsFromUserDefaults() -> [String: String] {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? "N/A"
        let firstname = UserDefaults.standard.string(forKey: "userFirstname") ?? "N/A"
        let surname = UserDefaults.standard.string(forKey: "userSurname") ?? "N/A"
        let email = UserDefaults.standard.string(forKey: "userEmail") ?? "N/A"
        let friendTag = UserDefaults.standard.string(forKey: "userFriendTag") ?? "N/A"
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "N/A"
        
        return [
            "token" : token,
            "firstname": firstname,
            "surname": surname,
            "email": email,
            "friendTag": friendTag,
            "userId": userId
        ]
    }

    
}

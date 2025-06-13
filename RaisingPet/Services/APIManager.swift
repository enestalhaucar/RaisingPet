//
//  APIManager.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 9.06.2025.
//

import Foundation

struct APIManager {

    static let baseURL = "http://3.74.213.54:3000/api/v1"

    struct Endpoints {
        // Auth Endpoints
        struct Auth {
            static let login = "\(baseURL)/users/login"
            static let signup = "\(baseURL)/users/signup"
            static let me = "\(baseURL)/users/me"
            static let updateMe = "\(baseURL)/users/update-me"
        }

        // Friends Endpoints
        struct Friends {
            static let searchFriendWithTag = "\(baseURL)/friends/search"
            static let sendRequest = "\(baseURL)/friends/send-request"
            static let acceptRequest = "\(baseURL)/friends/accept-request"
            static let rejectRequest = "\(baseURL)/friends/reject-request"
            static let list = "\(baseURL)/friends/list"
            static let removeFriend = "\(baseURL)/friends/remove-friend"
        }

        // Pets Endpoints
        struct Pets {
            static let getPets = "\(baseURL)/pets/my-pets"
            static let buyPetItem = "\(baseURL)/pets/buy-pet-item"
            static let petItemInteraction = "\(baseURL)/pets/pet-item-interaction"
            static let deletePet = "\(baseURL)/pets/:id"

        }

        struct Package {
            static let buyPackageItems = "\(baseURL)/package/buy-package-item"
        }

        // Shop Endpoints
        struct Shop {
            static let getAllShopItems = "\(baseURL)/shop/get-all-shop-items"
            static let buyItem = "\(baseURL)/shop/buy-item"

        }

        // Inventory Endpoints
        struct Inventory {
            static let myInventory = "\(baseURL)/inventory/my-inventory"
            static let hatchPets = "\(baseURL)/inventory/hatch-pets"
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

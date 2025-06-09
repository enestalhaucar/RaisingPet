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
    
    func getUserDetailsFromUserDefaults() -> [String: String] {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? "N/A"
        let firstname = UserDefaults.standard.string(forKey: "userFirstname") ?? "N/A"
        let surname = UserDefaults.standard.string(forKey: "userSurname") ?? "N/A"
        let email = UserDefaults.standard.string(forKey: "userEmail") ?? "N/A"
        let friendName = UserDefaults.standard.string(forKey: "userFriendName") ?? "N/A"
        let friendSurname = UserDefaults.standard.string(forKey: "userFriendSurname") ?? "N/A"
        let friendTag = UserDefaults.standard.string(forKey: "userFriendTag") ?? "N/A"
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "N/A"
        let phoneNumber = UserDefaults.standard.string(forKey: "userPhoneNumber") ?? "N/A"
        let photo = UserDefaults.standard.string(forKey: "userPhoto") ?? "N/A"
        let photoURL = UserDefaults.standard.string(forKey: "userPhotoURL") ?? "N/A"
        
        return [
            "token": token,
            "firstname": firstname,
            "surname": surname,
            "email": email,
            "friendTag": friendTag,
            "userId": userId,
            "phoneNumber": phoneNumber,
            "photo": photo,
            "photoURL": photoURL
        ]
    }

    func saveFriendDetailsToUserDefaults(firstname: String, id: String) {
        UserDefaults.standard.set(firstname, forKey: "friendFirstname")
        UserDefaults.standard.set(id, forKey: "friendId")
    }

    func getFriendDetailsFromUserDefaults() -> [String: String]? {
        guard let firstname = UserDefaults.standard.string(forKey: "friendFirstname"),
              let id = UserDefaults.standard.string(forKey: "friendId") else {
            return nil
        }
        return ["firstname": firstname, "id": id]
    }

    func clearFriendDetailsFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "friendFirstname")
        UserDefaults.standard.removeObject(forKey: "friendId")
    }

    
}

//
//  UserManager.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 14.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct DBUser {
    let userId : String
    let name : String?
    let email : String
    let profilePhotoUrl : String?
    let wallpaperUrl : String?
    let dateCreated : Date?
    
    
}

final class UserManager {
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(auth : AuthDataResultModel) async throws {
        var userData : [String : Any] = [
            "user_id" : auth.uid,
            "date_created" : Timestamp(),
            "email" : auth.email
        ]
        if let profilePhotoUrl = auth.profilePhotoUrl {
            userData["photo_url"] = profilePhotoUrl
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId : String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data() else {
            throw URLError(.badServerResponse)
        }
        let email = data["email"] as! String
        let profilePhotoUrl = data["profile_photo_url"] as? String
        let wallpaperUrl = data["wallpaper_url"] as? String
        let dateCreated = data["date_created"] as? Date
        
        
        return DBUser(userId: userId, name: nil, email: email, profilePhotoUrl: profilePhotoUrl, wallpaperUrl: wallpaperUrl, dateCreated: dateCreated)
    }
}

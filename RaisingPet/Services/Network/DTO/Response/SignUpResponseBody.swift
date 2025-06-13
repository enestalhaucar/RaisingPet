//
//  SignUpResponseBody.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation
import Alamofire

// MARK: Sign Up Response
struct SignUpResponseBody: Codable {
    let status: String
    let token: String
    let data: UserData
}

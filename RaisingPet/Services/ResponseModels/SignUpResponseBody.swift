//
//  SignUpResponseBody.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 24.01.2025.
//

import Foundation
import Alamofire

// MARK: Sign Up Response
struct SignUpResponseBody : Codable {
    let status : String
    let token : String
    let data : UserData
}

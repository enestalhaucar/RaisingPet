//
//  ErrorResponse.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 10.12.2024.
//
import Foundation
import Alamofire

struct ErrorResponseModel: Codable {
    let status: String
    let message: String
}

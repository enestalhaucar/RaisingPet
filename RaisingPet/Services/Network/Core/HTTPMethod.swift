//
//  HTTPMethod.swift
//  RaisingPet
//
//  Created by Network Layer Update on 15.05.2024.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    
    var alamofireMethod: Alamofire.HTTPMethod {
        return Alamofire.HTTPMethod(rawValue: self.rawValue)
    }
} 
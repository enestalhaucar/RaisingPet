//
//  Endpoint.swift
//  RaisingPet
//
//  Created by Network Layer Update on 15.05.2024.
//

import Foundation
import Alamofire

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var encoding: ParameterEncoding { get }
    var requiresAuthentication: Bool { get }
}

extension Endpoint {
    var url: URL? {
        return URL(string: baseURL + path)
    }
    
    var baseURL: String {
        return Utilities.Constants.baseURL
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
    
    var requiresAuthentication: Bool {
        return true
    }
} 
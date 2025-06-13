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
        return APIManager.baseURL
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

    func asURLRequest() throws -> URLRequest {
        guard let url = self.url else {
            throw AFError.invalidURL(url: baseURL + path)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        // Set default headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Set endpoint-specific headers
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        // Set Authorization header if required
        if requiresAuthentication {
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }

        // Encode parameters
        return try encoding.encode(urlRequest, with: parameters)
    }
}

//
//  NetworkError.swift
//  RaisingPet
//
//  Created by Network Layer Update on 15.05.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError(Error)
    case serverError(statusCode: Int, message: String?)
    case unauthorized
    case timeOut
    case noInternetConnection
    case unknown(Error?)
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .invalidResponse:
            return "Geçersiz sunucu yanıtı"
        case .invalidData:
            return "Geçersiz veri"
        case .decodingError(let error):
            return "Veri çözümleme hatası: \(error.localizedDescription)"
        case .serverError(let statusCode, let message):
            return message ?? "Sunucu hatası: \(statusCode)"
        case .unauthorized:
            return "Yetkilendirme hatası"
        case .timeOut:
            return "Bağlantı zaman aşımına uğradı"
        case .noInternetConnection:
            return "İnternet bağlantısı yok"
        case .unknown(let error):
            return error?.localizedDescription ?? "Bilinmeyen hata"
        }
    }
}
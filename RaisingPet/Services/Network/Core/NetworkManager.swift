//
//  NetworkManager.swift
//  RaisingPet
//
//  Created by Network Layer Update on 15.05.2024.
//

import Foundation
import Alamofire
import Combine

protocol NetworkManaging {
    func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T
    func requestWithPublisher<T: Decodable>(endpoint: Endpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError>
    func requestWithCompletion<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkManager: NetworkManaging {
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Async/Await API
    func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T {
        do {
            // URLRequest'i merkezi fonksiyondan alıyoruz.
            let urlRequest = try endpoint.asURLRequest()

            // Alamofire isteğini çalıştırıp, cevabın tamamını (DataResponse) alıyoruz.
            let response = await AF.request(urlRequest).validate().serializingData().response

            // Dönen cevabın sonucunu (başarılı/başarısız) kontrol ediyoruz.
            switch response.result {
            case .success(let data):
                // Başarılıysa, gelen veriyi decode edip geri dönüyoruz.
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch let decodingError {
                    throw NetworkError.decodingError(decodingError)
                }

            case .failure(let afError):
                // Başarısızsa, Alamofire hatasını kendi NetworkError tipimize çeviriyoruz.
                if let underlyingError = afError.underlyingError as? URLError, underlyingError.code == .timedOut {
                    throw NetworkError.timeOut
                }
                if let statusCode = afError.responseCode {
                    if statusCode == 401 {
                        throw NetworkError.unauthorized
                    }

                    // Sunucudan gelen hata mesajını decode etmeye çalışıyoruz.
                    // Artık 'response.data' ya erişimimiz var.
                    if let data = response.data {
                        do {
                            let serverError = try JSONDecoder().decode(ErrorResponseModel.self, from: data)
                            throw NetworkError.serverError(statusCode: statusCode, message: serverError.message)
                        } catch {
                            let errorString = String(data: data, encoding: .utf8) ?? afError.localizedDescription
                            throw NetworkError.serverError(statusCode: statusCode, message: errorString)
                        }
                    }
                    throw NetworkError.serverError(statusCode: statusCode, message: afError.localizedDescription)
                }
                throw NetworkError.unknown(afError)
            }
        } catch {
            // Bu blok, asURLRequest'ten veya yukarıdaki switch'ten kaynaklanan diğer hataları yakalar.
            if let networkError = error as? NetworkError {
                throw networkError
            }
            throw NetworkError.unknown(error)
        }
    }
    
    // MARK: - Combine API
    func requestWithPublisher<T: Decodable>(endpoint: Endpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var headers: HTTPHeaders = [:]
        
        // Add auth token if required
        if endpoint.requiresAuthentication {
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                headers["Authorization"] = "Bearer \(token)"
            } else {
                return Fail(error: NetworkError.unauthorized).eraseToAnyPublisher()
            }
        }
        
        // Add any custom headers from endpoint
        if let customHeaders = endpoint.headers {
            for (key, value) in customHeaders {
                headers[key] = value
            }
        }
        
        return AF.request(
            url,
            method: endpoint.method.alamofireMethod,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: headers
        )
        .validate()
        .publishData()
        .tryMap { response -> Data in
            // Handle HTTP errors
            if let statusCode = response.response?.statusCode {
                if statusCode == 401 {
                    throw NetworkError.unauthorized
                } else if statusCode >= 400 {
                    // Try to decode server error message
                    if let data = response.data {
                        do {
                            let serverError = try JSONDecoder().decode(ErrorResponseModel.self, from: data)
                            throw NetworkError.serverError(statusCode: statusCode, message: serverError.message)
                        } catch {
                            throw NetworkError.serverError(statusCode: statusCode, message: nil)
                        }
                    } else {
                        throw NetworkError.serverError(statusCode: statusCode, message: nil)
                    }
                }
            }
            
            guard let data = response.data else {
                throw NetworkError.invalidData
            }
            
            return data
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .mapError { error in
            if let networkError = error as? NetworkError {
                return networkError
            } else if error is DecodingError {
                return NetworkError.decodingError(error)
            } else {
                return NetworkError.unknown(error)
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Completion Handler API
    func requestWithCompletion<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var headers: HTTPHeaders = [:]
        
        // Add auth token if required
        if endpoint.requiresAuthentication {
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                headers["Authorization"] = "Bearer \(token)"
            } else {
                completion(.failure(NetworkError.unauthorized))
                return
            }
        }
        
        // Add any custom headers from endpoint
        if let customHeaders = endpoint.headers {
            for (key, value) in customHeaders {
                headers[key] = value
            }
        }
        
        AF.request(
            url,
            method: endpoint.method.alamofireMethod,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: headers
        )
        .validate()
        .responseData { response in
            // Handle HTTP errors
            if let statusCode = response.response?.statusCode {
                if statusCode == 401 {
                    completion(.failure(NetworkError.unauthorized))
                    return
                } else if statusCode >= 400 {
                    // Try to decode server error message
                    if let data = response.data {
                        do {
                            let serverError = try JSONDecoder().decode(ErrorResponseModel.self, from: data)
                            completion(.failure(NetworkError.serverError(statusCode: statusCode, message: serverError.message)))
                        } catch {
                            completion(.failure(NetworkError.serverError(statusCode: statusCode, message: nil)))
                        }
                    } else {
                        completion(.failure(NetworkError.serverError(statusCode: statusCode, message: nil)))
                    }
                    return
                }
            }
            
            guard let data = response.data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }
    }
} 
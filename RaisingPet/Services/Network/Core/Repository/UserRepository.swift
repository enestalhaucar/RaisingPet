import Foundation
import Alamofire
import Combine
import UIKit

// MARK: - User Endpoints
enum UserEndpoint: Endpoint {
    case updateProfile(
        firstName: String?,
        lastName: String?,
        email: String?,
        phoneNumber: String?
    )
    case uploadProfilePhoto(photo: UIImage)
    
    // Could add other user-related endpoints like password change, etc.
    
    var path: String {
        switch self {
        case .updateProfile, .uploadProfilePhoto:
            return "/users/update-me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .updateProfile, .uploadProfilePhoto:
            return .patch
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .updateProfile(let firstName, let lastName, let email, let phoneNumber):
            var params: [String: Any] = [:]
            if let firstName = firstName { params["firstname"] = firstName }
            if let lastName = lastName { params["surname"] = lastName }
            if let email = email { params["email"] = email }
            if let phoneNumber = phoneNumber { params["phoneNumber"] = phoneNumber }
            return params
        case .uploadProfilePhoto:
            return nil // We'll handle this specially with multipart
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .uploadProfilePhoto:
            return URLEncoding.default // Will be overridden
        default:
            return JSONEncoding.default
        }
    }
    
    var requiresAuthentication: Bool {
        return true
    }
}

// MARK: - User Repository Protocol
protocol UserRepository: BaseRepository {
    func updateProfile(
        firstName: String?,
        lastName: String?,
        email: String?,
        phoneNumber: String?
    ) async throws -> GetMeResponseModel
    
    func uploadProfilePhoto(photo: UIImage) async throws -> GetMeResponseModel
    
    func updateProfileWithPhoto(
        firstName: String?,
        lastName: String?,
        email: String?,
        phoneNumber: String?,
        photo: UIImage?
    ) async throws -> GetMeResponseModel
    
    func getUserImage(imageURL: String) async throws -> Data
    
    func logOut()
    func getUserDetails() -> [String: String]
    
    // Combine variants
    func updateProfilePublisher(
        firstName: String?,
        lastName: String?,
        email: String?,
        phoneNumber: String?
    ) -> AnyPublisher<GetMeResponseModel, NetworkError>
}

// MARK: - User Repository Implementation
class UserRepositoryImpl: UserRepository {
    let networkManager: NetworkManaging
    
    required init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func updateProfile(
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        phoneNumber: String? = nil
    ) async throws -> GetMeResponseModel {
        let response = try await networkManager.request(
            endpoint: UserEndpoint.updateProfile(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phoneNumber: phoneNumber
            ),
            responseType: GetMeResponseModel.self
        )
        
        // Update local storage with new user data
        if let userData = response.data?.data {
            UserDefaults.standard.set(userData.firstname, forKey: "userFirstname")
            UserDefaults.standard.set(userData.surname, forKey: "userSurname")
            UserDefaults.standard.set(userData.email, forKey: "userEmail")
            if let phoneNumber = userData.phoneNumber {
                UserDefaults.standard.set(phoneNumber, forKey: "userPhoneNumber")
            }
            if let photo = userData.photo {
                UserDefaults.standard.set(photo, forKey: "userPhoto")
            }
            if let photoURL = userData.photoURL {
                UserDefaults.standard.set(photoURL, forKey: "userPhotoURL")
            }
        }
        
        return response
    }
    
    func uploadProfilePhoto(photo: UIImage) async throws -> GetMeResponseModel {
        // This function would need a custom implementation for multipart form data upload
        // This is a temporary implementation that would need to be replaced with proper multipart handling
        
        let url = URL(string: Utilities.Constants.baseURL + UserEndpoint.uploadProfilePhoto(photo: photo).path)!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add the photo
        if let imageData = photo.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Close the boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Perform the request manually
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verify the response
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0, message: nil)
        }
        
        // Decode the response
        let decoder = JSONDecoder()
        let responseModel = try decoder.decode(GetMeResponseModel.self, from: data)
        
        return responseModel
    }
    
    func updateProfileWithPhoto(
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        phoneNumber: String? = nil,
        photo: UIImage? = nil
    ) async throws -> GetMeResponseModel {
        // This function would need a custom implementation for multipart form data upload
        // that includes both text fields and photo
        
        let url = URL(string: Utilities.Constants.baseURL + UserEndpoint.uploadProfilePhoto(photo: UIImage()).path)!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add text fields
        if let firstName = firstName {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"firstname\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(firstName)\r\n".data(using: .utf8)!)
        }
        
        if let lastName = lastName {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"surname\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(lastName)\r\n".data(using: .utf8)!)
        }
        
        if let email = email {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(email)\r\n".data(using: .utf8)!)
        }
        
        if let phoneNumber = phoneNumber {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"phoneNumber\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(phoneNumber)\r\n".data(using: .utf8)!)
        }
        
        // Add the photo if provided
        if let photo = photo, let imageData = photo.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Close the boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Perform the request manually
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verify the response
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0, message: nil)
        }
        
        // Decode the response
        let decoder = JSONDecoder()
        let responseModel = try decoder.decode(GetMeResponseModel.self, from: data)
        
        // Update UserDefaults with the new data
        if let userData = responseModel.data?.data {
            UserDefaults.standard.set(userData.firstname, forKey: "userFirstname")
            UserDefaults.standard.set(userData.surname, forKey: "userSurname")
            UserDefaults.standard.set(userData.email, forKey: "userEmail")
            if let phoneNumber = userData.phoneNumber {
                UserDefaults.standard.set(phoneNumber, forKey: "userPhoneNumber")
            }
            if let photoValue = userData.photo {
                UserDefaults.standard.set(photoValue, forKey: "userPhoto")
            }
            if let photoURL = userData.photoURL {
                UserDefaults.standard.set(photoURL, forKey: "userPhotoURL")
            }
            
            // Save the photo to UserDefaults
            if let photo = photo, let photoData = photo.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(photoData, forKey: "userProfilePhoto")
            }
        }
        
        return responseModel
    }
    
    func getUserImage(imageURL: String) async throws -> Data {
        // Check if the URL is empty or "N/A"
        if imageURL.isEmpty || imageURL == "N/A" {
            throw NetworkError.invalidURL
        }
        
        // Normalize the URL to ensure it's properly formed
        let normalizedURL: String
        
        // Case 1: If the URL already has a protocol (http:// or https://)
        if imageURL.hasPrefix("http://") || imageURL.hasPrefix("https://") {
            normalizedURL = imageURL
        }
        // Case 2: If the URL starts with our server address but without protocol
        else if imageURL.contains("3.74.213.54") {
            normalizedURL = "http://" + imageURL
        }
        // Case 3: If it's a relative path that should be appended to the base URL
        else {
            // Ensure we don't duplicate path components
            if imageURL.hasPrefix("/") {
                normalizedURL = Utilities.Constants.baseURL + imageURL
            } else {
                normalizedURL = Utilities.Constants.baseURL + "/" + imageURL
            }
        }
        
        print("Requesting image from normalized URL: \(normalizedURL)")
        
        guard let url = URL(string: normalizedURL) else {
            print("Invalid URL string: \(normalizedURL)")
            throw NetworkError.invalidURL
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check if the response is valid
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                print("Image download failed with status code: \(httpResponse.statusCode)")
                
                // For 404 errors on profile images, you might want to return a placeholder image
                if httpResponse.statusCode == 404 {
                    // If we have a placeholder image in the assets, return its data
                    if let placeholderImage = UIImage(named: "placeholder"),
                       let placeholderData = placeholderImage.pngData() {
                        return placeholderData
                    }
                }
                
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: "Failed to load image")
            }
            
            return data
        } catch {
            print("Error downloading image: \(error.localizedDescription)")
            throw NetworkError.unknown(error)
        }
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userFirstname")
        UserDefaults.standard.removeObject(forKey: "userSurname")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userPhoneNumber")
        UserDefaults.standard.removeObject(forKey: "userFriendTag")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userProfilePhoto")
        UserDefaults.standard.removeObject(forKey: "userPhoto")
        UserDefaults.standard.removeObject(forKey: "userPhotoURL")
        
        // Clear any cached images
        UserDefaults.standard.removeObject(forKey: "userProfilePhoto")
        
        // Clear all data that might be associated with this user
        let userRelatedKeys = UserDefaults.standard.dictionaryRepresentation().keys.filter { key in
            key.hasPrefix("user") || key.contains("profile") || key.contains("Photo")
        }
        
        for key in userRelatedKeys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        print("User has been fully logged out and all data cleared")
    }
    
    func getUserDetails() -> [String: String] {
        return Utilities.shared.getUserDetailsFromUserDefaults()
    }
    
    // MARK: - Combine API
    func updateProfilePublisher(
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        phoneNumber: String? = nil
    ) -> AnyPublisher<GetMeResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: UserEndpoint.updateProfile(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phoneNumber: phoneNumber
            ),
            responseType: GetMeResponseModel.self
        )
        .handleEvents(receiveOutput: { response in
            // Update local storage with new user data
            if let userData = response.data?.data {
                UserDefaults.standard.set(userData.firstname, forKey: "userFirstname")
                UserDefaults.standard.set(userData.surname, forKey: "userSurname")
                UserDefaults.standard.set(userData.email, forKey: "userEmail")
                if let phoneNumber = userData.phoneNumber {
                    UserDefaults.standard.set(phoneNumber, forKey: "userPhoneNumber")
                }
                if let photo = userData.photo {
                    UserDefaults.standard.set(photo, forKey: "userPhoto")
                }
                if let photoURL = userData.photoURL {
                    UserDefaults.standard.set(photoURL, forKey: "userPhotoURL")
                }
            }
        })
        .eraseToAnyPublisher()
    }
} 

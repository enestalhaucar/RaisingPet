import Foundation
import Combine

// MARK: - UserProfile Endpoints
enum UserProfileEndpoint: Endpoint {
    case getMe
    
    var path: String {
        switch self {
        case .getMe:
            return "/users/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMe:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var requiresAuthentication: Bool {
        return true
    }
}

// MARK: - UserProfile Repository Protocol
protocol UserProfileRepository: BaseRepository {
    func getCurrentUser() async throws -> GetMeResponseModel
    
    // Combine variant
    func getCurrentUserPublisher() -> AnyPublisher<GetMeResponseModel, NetworkError>
}

// MARK: - UserProfile Repository Implementation
class UserProfileRepositoryImpl: UserProfileRepository {
    let networkManager: NetworkManaging
    
    required init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func getCurrentUser() async throws -> GetMeResponseModel {
        return try await networkManager.request(
            endpoint: UserProfileEndpoint.getMe,
            responseType: GetMeResponseModel.self
        )
    }
    
    // MARK: - Combine API
    func getCurrentUserPublisher() -> AnyPublisher<GetMeResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: UserProfileEndpoint.getMe,
            responseType: GetMeResponseModel.self
        )
    }
} 
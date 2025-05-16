import Foundation
import Combine

// MARK: - Auth Endpoints
enum AuthEndpoint: Endpoint {
    case login(email: String, password: String)
    case signup(firstName: String, lastName: String, email: String, password: String, phoneNumber: String)
    case me
    case updateMe(firstName: String?, lastName: String?, email: String?, phoneNumber: String?)
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .signup:
            return "/users/signup"
        case .me:
            return "/users/me"
        case .updateMe:
            return "/users/update-me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .signup:
            return .post
        case .me:
            return .get
        case .updateMe:
            return .patch
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .signup(let firstName, let lastName, let email, let password, let phoneNumber):
            return [
                "firstname": firstName,
                "surname": lastName,
                "email": email,
                "password": password,
                "phoneNumber": phoneNumber
            ]
        case .me:
            return nil
        case .updateMe(let firstName, let lastName, let email, let phoneNumber):
            var params: [String: Any] = [:]
            if let firstName = firstName { params["firstname"] = firstName }
            if let lastName = lastName { params["surname"] = lastName }
            if let email = email { params["email"] = email }
            if let phoneNumber = phoneNumber { params["phoneNumber"] = phoneNumber }
            return params
        }
    }
    
    var requiresAuthentication: Bool {
        switch self {
        case .login, .signup:
            return false
        case .me, .updateMe:
            return true
        }
    }
}

// MARK: - Auth Repository Protocol
protocol AuthRepository: BaseRepository {
    func login(email: String, password: String) async throws -> LoginResponseModel
    func signup(firstName: String, lastName: String, email: String, password: String, phoneNumber: String) async throws -> SignUpResponseBody
    func getMe() async throws -> GetMeResponseModel
    func updateMe(firstName: String?, lastName: String?, email: String?, phoneNumber: String?) async throws -> GetMeResponseModel
    
    // Combine variants
    func loginPublisher(email: String, password: String) -> AnyPublisher<LoginResponseModel, NetworkError>
    func signupPublisher(firstName: String, lastName: String, email: String, password: String, phoneNumber: String) -> AnyPublisher<SignUpResponseBody, NetworkError>
    func getMePublisher() -> AnyPublisher<GetMeResponseModel, NetworkError>
    func updateMePublisher(firstName: String?, lastName: String?, email: String?, phoneNumber: String?) -> AnyPublisher<GetMeResponseModel, NetworkError>
}

// MARK: - Auth Repository Implementation
class AuthRepositoryImpl: AuthRepository {
    let networkManager: NetworkManaging
    
    required init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func login(email: String, password: String) async throws -> LoginResponseModel {
        return try await networkManager.request(
            endpoint: AuthEndpoint.login(email: email, password: password), 
            responseType: LoginResponseModel.self
        )
    }
    
    func signup(firstName: String, lastName: String, email: String, password: String, phoneNumber: String) async throws -> SignUpResponseBody {
        return try await networkManager.request(
            endpoint: AuthEndpoint.signup(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                phoneNumber: phoneNumber
            ),
            responseType: SignUpResponseBody.self
        )
    }
    
    func getMe() async throws -> GetMeResponseModel {
        return try await networkManager.request(
            endpoint: AuthEndpoint.me,
            responseType: GetMeResponseModel.self
        )
    }
    
    func updateMe(firstName: String? = nil, lastName: String? = nil, email: String? = nil, phoneNumber: String? = nil) async throws -> GetMeResponseModel {
        return try await networkManager.request(
            endpoint: AuthEndpoint.updateMe(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phoneNumber: phoneNumber
            ),
            responseType: GetMeResponseModel.self
        )
    }
    
    // MARK: - Combine API
    func loginPublisher(email: String, password: String) -> AnyPublisher<LoginResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: AuthEndpoint.login(email: email, password: password),
            responseType: LoginResponseModel.self
        )
    }
    
    func signupPublisher(firstName: String, lastName: String, email: String, password: String, phoneNumber: String) -> AnyPublisher<SignUpResponseBody, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: AuthEndpoint.signup(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                phoneNumber: phoneNumber
            ),
            responseType: SignUpResponseBody.self
        )
    }
    
    func getMePublisher() -> AnyPublisher<GetMeResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: AuthEndpoint.me,
            responseType: GetMeResponseModel.self
        )
    }
    
    func updateMePublisher(firstName: String? = nil, lastName: String? = nil, email: String? = nil, phoneNumber: String? = nil) -> AnyPublisher<GetMeResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: AuthEndpoint.updateMe(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phoneNumber: phoneNumber
            ),
            responseType: GetMeResponseModel.self
        )
    }
} 

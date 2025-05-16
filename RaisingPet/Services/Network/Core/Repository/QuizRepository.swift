import Foundation
import Alamofire
import Combine

// MARK: - Quiz Endpoints
enum QuizEndpoint: Endpoint {
    case getQuizById(id: String)
    case getUserQuizzes
    case takeQuiz(quizId: String, answers: [String: String])
    case quizResultForQuiz(quizId: String)
    
    var path: String {
        switch self {
        case .getQuizById(let id):
            return "/quiz/\(id)"
        case .getUserQuizzes:
            return "/quiz/myQuizzes"
        case .takeQuiz:
            return "/quiz/takeQuiz"
        case .quizResultForQuiz:
            return "/quiz/getQuizResultForQuiz"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getQuizById, .getUserQuizzes, .quizResultForQuiz:
            return .get
        case .takeQuiz:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getQuizById:
            return nil
        case .getUserQuizzes:
            return nil
        case .takeQuiz(let quizId, let answers):
            return ["quizId": quizId, "answers": answers]
        case .quizResultForQuiz(let quizId):
            return ["quizId": quizId]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .quizResultForQuiz:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
}

// MARK: - Quiz Repository Protocol
protocol QuizRepository: BaseRepository {
    func getQuizById(id: String) async throws -> QuizDetailsResponseModel
    func getUserQuizzes() async throws -> UserQuizzesResponseModel
    func takeQuiz(quizId: String, answers: [String: String]) async throws -> QuizResultResponseModel
    func quizResultForQuiz(quizId: String) async throws -> QuizResultResponseModel
    
    // Combine variants
    func getQuizByIdPublisher(id: String) -> AnyPublisher<QuizDetailsResponseModel, NetworkError>
    func getUserQuizzesPublisher() -> AnyPublisher<UserQuizzesResponseModel, NetworkError>
    func takeQuizPublisher(quizId: String, answers: [String: String]) -> AnyPublisher<QuizResultResponseModel, NetworkError>
    func quizResultForQuizPublisher(quizId: String) -> AnyPublisher<QuizResultResponseModel, NetworkError>
}

// MARK: - Quiz Repository Implementation
class QuizRepositoryImpl: QuizRepository {
    let networkManager: NetworkManaging
    
    required init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func getQuizById(id: String) async throws -> QuizDetailsResponseModel {
        return try await networkManager.request(
            endpoint: QuizEndpoint.getQuizById(id: id),
            responseType: QuizDetailsResponseModel.self
        )
    }
    
    func getUserQuizzes() async throws -> UserQuizzesResponseModel {
        return try await networkManager.request(
            endpoint: QuizEndpoint.getUserQuizzes,
            responseType: UserQuizzesResponseModel.self
        )
    }
    
    func takeQuiz(quizId: String, answers: [String: String]) async throws -> QuizResultResponseModel {
        return try await networkManager.request(
            endpoint: QuizEndpoint.takeQuiz(quizId: quizId, answers: answers),
            responseType: QuizResultResponseModel.self
        )
    }
    
    func quizResultForQuiz(quizId: String) async throws -> QuizResultResponseModel {
        return try await networkManager.request(
            endpoint: QuizEndpoint.quizResultForQuiz(quizId: quizId),
            responseType: QuizResultResponseModel.self
        )
    }
    
    // MARK: - Combine API
    func getQuizByIdPublisher(id: String) -> AnyPublisher<QuizDetailsResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: QuizEndpoint.getQuizById(id: id),
            responseType: QuizDetailsResponseModel.self
        )
    }
    
    func getUserQuizzesPublisher() -> AnyPublisher<UserQuizzesResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: QuizEndpoint.getUserQuizzes,
            responseType: UserQuizzesResponseModel.self
        )
    }
    
    func takeQuizPublisher(quizId: String, answers: [String: String]) -> AnyPublisher<QuizResultResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: QuizEndpoint.takeQuiz(quizId: quizId, answers: answers),
            responseType: QuizResultResponseModel.self
        )
    }
    
    func quizResultForQuizPublisher(quizId: String) -> AnyPublisher<QuizResultResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: QuizEndpoint.quizResultForQuiz(quizId: quizId),
            responseType: QuizResultResponseModel.self
        )
    }
} 

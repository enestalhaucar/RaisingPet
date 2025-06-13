import Foundation
import Combine
import Alamofire

// MARK: - Friends Endpoints
enum FriendsEndpoint: Endpoint {
    case searchFriendWithTag(tag: String)
    case sendRequest(friendId: String)
    case acceptRequest(requestId: String)
    case rejectRequest(requestId: String)
    case listFriends
    case removeFriend(friendId: String)

    var path: String {
        switch self {
        case .searchFriendWithTag:
            return "/friends/search"
        case .sendRequest:
            return "/friends/send-request"
        case .acceptRequest:
            return "/friends/accept-request"
        case .rejectRequest:
            return "/friends/reject-request"
        case .listFriends:
            return "/friends/list"
        case .removeFriend:
            return "/friends/remove-friend"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listFriends:
            return .get
        case .searchFriendWithTag:
            return .post
        case .sendRequest, .acceptRequest, .rejectRequest, .removeFriend:
            return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .searchFriendWithTag(let tag):
            return ["friendTag": tag]
        case .sendRequest(let friendId):
            return ["friendId": friendId]
        case .acceptRequest(let requestId):
            return ["requestId": requestId]
        case .rejectRequest(let requestId):
            return ["requestId": requestId]
        case .listFriends:
            return nil
        case .removeFriend(let friendId):
            return ["friendId": friendId]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .searchFriendWithTag:
            return JSONEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

// MARK: - Friends Repository Protocol
protocol FriendsRepository: BaseRepository {
    func searchFriendWithTag(tag: String) async throws -> SearchFriendWithTagResponse
    func sendRequest(friendId: String) async throws
    func acceptRequest(requestId: String) async throws
    func rejectRequest(requestId: String) async throws
    func listFriends() async throws -> FriendsResponseModel
    func removeFriend(friendId: String) async throws

    // Combine variants
    func searchFriendWithTagPublisher(tag: String) -> AnyPublisher<SearchFriendWithTagResponse, NetworkError>
    func sendRequestPublisher(friendId: String) -> AnyPublisher<Void, NetworkError>
    func acceptRequestPublisher(requestId: String) -> AnyPublisher<Void, NetworkError>
    func rejectRequestPublisher(requestId: String) -> AnyPublisher<Void, NetworkError>
    func listFriendsPublisher() -> AnyPublisher<FriendsResponseModel, NetworkError>
    func removeFriendPublisher(friendId: String) -> AnyPublisher<Void, NetworkError>
}

// MARK: - Friends Repository Implementation
class FriendsRepositoryImpl: FriendsRepository {
    let networkManager: NetworkManaging

    required init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func searchFriendWithTag(tag: String) async throws -> SearchFriendWithTagResponse {
        return try await networkManager.request(
            endpoint: FriendsEndpoint.searchFriendWithTag(tag: tag),
            responseType: SearchFriendWithTagResponse.self
        )
    }

    func sendRequest(friendId: String) async throws {
        struct EmptyResponse: Decodable {}
        _ = try await networkManager.request(
            endpoint: FriendsEndpoint.sendRequest(friendId: friendId),
            responseType: EmptyResponse.self
        )
    }

    func acceptRequest(requestId: String) async throws {
        struct EmptyResponse: Decodable {}
        _ = try await networkManager.request(
            endpoint: FriendsEndpoint.acceptRequest(requestId: requestId),
            responseType: EmptyResponse.self
        )
    }

    func rejectRequest(requestId: String) async throws {
        struct EmptyResponse: Decodable {}
        _ = try await networkManager.request(
            endpoint: FriendsEndpoint.rejectRequest(requestId: requestId),
            responseType: EmptyResponse.self
        )
    }

    func listFriends() async throws -> FriendsResponseModel {
        return try await networkManager.request(
            endpoint: FriendsEndpoint.listFriends,
            responseType: FriendsResponseModel.self
        )
    }

    func removeFriend(friendId: String) async throws {
        struct EmptyResponse: Decodable {}
        _ = try await networkManager.request(
            endpoint: FriendsEndpoint.removeFriend(friendId: friendId),
            responseType: EmptyResponse.self
        )
    }

    // MARK: - Combine API
    func searchFriendWithTagPublisher(tag: String) -> AnyPublisher<SearchFriendWithTagResponse, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: FriendsEndpoint.searchFriendWithTag(tag: tag),
            responseType: SearchFriendWithTagResponse.self
        )
    }

    func sendRequestPublisher(friendId: String) -> AnyPublisher<Void, NetworkError> {
        struct EmptyResponse: Decodable {}
        return networkManager.requestWithPublisher(
            endpoint: FriendsEndpoint.sendRequest(friendId: friendId),
            responseType: EmptyResponse.self
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }

    func acceptRequestPublisher(requestId: String) -> AnyPublisher<Void, NetworkError> {
        struct EmptyResponse: Decodable {}
        return networkManager.requestWithPublisher(
            endpoint: FriendsEndpoint.acceptRequest(requestId: requestId),
            responseType: EmptyResponse.self
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }

    func rejectRequestPublisher(requestId: String) -> AnyPublisher<Void, NetworkError> {
        struct EmptyResponse: Decodable {}
        return networkManager.requestWithPublisher(
            endpoint: FriendsEndpoint.rejectRequest(requestId: requestId),
            responseType: EmptyResponse.self
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }

    func listFriendsPublisher() -> AnyPublisher<FriendsResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: FriendsEndpoint.listFriends,
            responseType: FriendsResponseModel.self
        )
    }

    func removeFriendPublisher(friendId: String) -> AnyPublisher<Void, NetworkError> {
        struct EmptyResponse: Decodable {}
        return networkManager.requestWithPublisher(
            endpoint: FriendsEndpoint.removeFriend(friendId: friendId),
            responseType: EmptyResponse.self
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }
}

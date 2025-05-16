import Foundation
import Combine

// MARK: - Shop Endpoints
enum ShopEndpoint: Endpoint {
    case getAllShopItems
    case buyItem(itemId: String)
    
    var path: String {
        switch self {
        case .getAllShopItems:
            return "/shop/get-all-shop-items"
        case .buyItem:
            return "/shop/buy-item"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllShopItems:
            return .get
        case .buyItem:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAllShopItems:
            return nil
        case .buyItem(let itemId):
            return ["itemId": itemId]
        }
    }
}

// MARK: - Shop Repository Protocol
protocol ShopRepository: BaseRepository {
    func getAllShopItems() async throws -> GetAllShopItems
    func buyItem(itemId: String) async throws -> Void
    
    // Combine variants
    func getAllShopItemsPublisher() -> AnyPublisher<GetAllShopItems, NetworkError>
    func buyItemPublisher(itemId: String) -> AnyPublisher<Void, NetworkError>
}

// MARK: - Shop Repository Implementation
class ShopRepositoryImpl: ShopRepository {
    let networkManager: NetworkManaging
    
    required init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func getAllShopItems() async throws -> GetAllShopItems {
        return try await networkManager.request(
            endpoint: ShopEndpoint.getAllShopItems,
            responseType: GetAllShopItems.self
        )
    }
    
    func buyItem(itemId: String) async throws {
        struct EmptyResponse: Decodable {}
        _ = try await networkManager.request(
            endpoint: ShopEndpoint.buyItem(itemId: itemId),
            responseType: EmptyResponse.self
        )
    }
    
    // MARK: - Combine API
    func getAllShopItemsPublisher() -> AnyPublisher<GetAllShopItems, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: ShopEndpoint.getAllShopItems,
            responseType: GetAllShopItems.self
        )
    }
    
    func buyItemPublisher(itemId: String) -> AnyPublisher<Void, NetworkError> {
        struct EmptyResponse: Decodable {}
        return networkManager.requestWithPublisher(
            endpoint: ShopEndpoint.buyItem(itemId: itemId),
            responseType: EmptyResponse.self
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }
}
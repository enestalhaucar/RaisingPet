import Foundation
import Combine

// MARK: - Inventory Endpoints
enum InventoryEndpoint: Endpoint {
    case getInventory
    case hatchPets(inventoryItemEggIds: [String])
    
    var path: String {
        switch self {
        case .getInventory:
            return "/inventory/my-inventory"
        case .hatchPets:
            return "/inventory/hatch-pets"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getInventory:
            return .get
        case .hatchPets:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getInventory:
            return nil
        case .hatchPets(let inventoryItemEggIds):
            return ["inventoryItemEggIds": inventoryItemEggIds]
        }
    }
}

// MARK: - Inventory Repository Protocol
protocol InventoryRepository: BaseRepository {
    func getInventory() async throws -> GetInventoryResponseModel
    func hatchPets(inventoryItemEggIds: [String]) async throws -> HatchPetsResponseModel
    
    // Combine variants
    func getInventoryPublisher() -> AnyPublisher<GetInventoryResponseModel, NetworkError>
    func hatchPetsPublisher(inventoryItemEggIds: [String]) -> AnyPublisher<HatchPetsResponseModel, NetworkError>
}

// MARK: - Inventory Repository Implementation
class InventoryRepositoryImpl: InventoryRepository {
    let networkManager: NetworkManaging
    
    required init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func getInventory() async throws -> GetInventoryResponseModel {
        return try await networkManager.request(
            endpoint: InventoryEndpoint.getInventory,
            responseType: GetInventoryResponseModel.self
        )
    }
    
    func hatchPets(inventoryItemEggIds: [String]) async throws -> HatchPetsResponseModel {
        return try await networkManager.request(
            endpoint: InventoryEndpoint.hatchPets(inventoryItemEggIds: inventoryItemEggIds),
            responseType: HatchPetsResponseModel.self
        )
    }
    
    // MARK: - Combine API
    func getInventoryPublisher() -> AnyPublisher<GetInventoryResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: InventoryEndpoint.getInventory,
            responseType: GetInventoryResponseModel.self
        )
    }
    
    func hatchPetsPublisher(inventoryItemEggIds: [String]) -> AnyPublisher<HatchPetsResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: InventoryEndpoint.hatchPets(inventoryItemEggIds: inventoryItemEggIds),
            responseType: HatchPetsResponseModel.self
        )
    }
} 

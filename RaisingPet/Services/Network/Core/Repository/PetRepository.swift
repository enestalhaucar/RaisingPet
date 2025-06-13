import Foundation
import Combine

// MARK: - Pet Endpoints
enum PetEndpoint: Endpoint {
    case getPets
    case buyPetItem(petId: String, itemId: String)
    case petItemInteraction(petId: String, petItemId: String)
    case deletePet(id: String)
    case changePetName(petId: String, petName: String, petCalling: String)

    var path: String {
        switch self {
        case .getPets:
            return "/pets/my-pets"
        case .buyPetItem:
            return "/pets/buy-pet-item"
        case .petItemInteraction:
            return "/pets/pet-item-interaction"
        case .deletePet(let id):
            return "/pets/\(id)"
        case .changePetName:
            return "/pets/change-pet-name"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPets:
            return .get
        case .buyPetItem, .petItemInteraction:
            return .post
        case .deletePet:
            return .delete
        case .changePetName:
            return .patch
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getPets:
            return nil
        case .buyPetItem(let petId, let itemId):
            return ["petId": petId, "itemId": itemId]
        case .petItemInteraction(let petId, let petItemId):
            return ["petId": petId, "petItemId": petItemId]
        case .deletePet:
            return nil
        case .changePetName(let petId, let petName, let petCalling):
            return ["petId": petId, "petName": petName, "petCalling": petCalling]
        }
    }
}

// MARK: - Pet Item Interaction Response
struct PetItemInteractionResponse: Codable {
    let status: String
    let message: String
    let data: PetItemInteractionData?
}

struct PetItemInteractionData: Codable {
    let pet: Pet?
    let inventory: Inventory?
}

// MARK: - Change Pet Name Models
struct ChangePetNameRequest: Codable {
    let petId: String
    let petName: String
    let petCalling: String
}

struct ChangePetNameResponse: Codable {
    let status: String
    let data: ChangePetNameData
}

struct ChangePetNameData: Codable {
    let pet: Pet
}

// MARK: - Pet Repository Protocol
protocol PetRepository: BaseRepository {
    func getPets() async throws -> GetPetsResponseModel
    func buyPetItem(petId: String, itemId: String) async throws
    func petItemInteraction(petId: String, petItemId: String) async throws
    func petItemInteractionWithResponse(petId: String, petItemId: String) async throws -> PetItemInteractionResponse
    func deletePet(id: String) async throws
    func changePetName(petId: String, petName: String, petCalling: String) async throws -> ChangePetNameResponse

    // Combine variants
    func getPetsPublisher() -> AnyPublisher<GetPetsResponseModel, NetworkError>
    func buyPetItemPublisher(petId: String, itemId: String) -> AnyPublisher<Void, NetworkError>
    func petItemInteractionPublisher(petId: String, petItemId: String) -> AnyPublisher<Void, NetworkError>
    func petItemInteractionWithResponsePublisher(petId: String, petItemId: String) -> AnyPublisher<PetItemInteractionResponse, NetworkError>
    func deletePetPublisher(id: String) -> AnyPublisher<Void, NetworkError>
    func changePetNamePublisher(petId: String, petName: String, petCalling: String) -> AnyPublisher<ChangePetNameResponse, NetworkError>
}

// MARK: - Pet Repository Implementation
class PetRepositoryImpl: PetRepository {
    let networkManager: NetworkManaging

    required init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func getPets() async throws -> GetPetsResponseModel {
        return try await networkManager.request(
            endpoint: PetEndpoint.getPets,
            responseType: GetPetsResponseModel.self
        )
    }

    func buyPetItem(petId: String, itemId: String) async throws {
        // Using EmptyResponse for void returns
        struct EmptyResponse: Decodable {}
        _ = try await networkManager.request(
            endpoint: PetEndpoint.buyPetItem(petId: petId, itemId: itemId),
            responseType: EmptyResponse.self
        )
    }

    func petItemInteraction(petId: String, petItemId: String) async throws {
        struct EmptyResponse: Decodable {}
        _ = try await networkManager.request(
            endpoint: PetEndpoint.petItemInteraction(petId: petId, petItemId: petItemId),
            responseType: EmptyResponse.self
        )
    }

    func petItemInteractionWithResponse(petId: String, petItemId: String) async throws -> PetItemInteractionResponse {
        return try await networkManager.request(
            endpoint: PetEndpoint.petItemInteraction(petId: petId, petItemId: petItemId),
            responseType: PetItemInteractionResponse.self
        )
    }

    func deletePet(id: String) async throws {
        struct EmptyResponse: Decodable {}
        _ = try await networkManager.request(
            endpoint: PetEndpoint.deletePet(id: id),
            responseType: EmptyResponse.self
        )
    }

    func changePetName(petId: String, petName: String, petCalling: String) async throws -> ChangePetNameResponse {
        return try await networkManager.request(
            endpoint: PetEndpoint.changePetName(petId: petId, petName: petName, petCalling: petCalling),
            responseType: ChangePetNameResponse.self
        )
    }

    // MARK: - Combine API
    func getPetsPublisher() -> AnyPublisher<GetPetsResponseModel, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: PetEndpoint.getPets,
            responseType: GetPetsResponseModel.self
        )
    }

    func buyPetItemPublisher(petId: String, itemId: String) -> AnyPublisher<Void, NetworkError> {
        struct EmptyResponse: Decodable {}
        return networkManager.requestWithPublisher(
            endpoint: PetEndpoint.buyPetItem(petId: petId, itemId: itemId),
            responseType: EmptyResponse.self
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }

    func petItemInteractionPublisher(petId: String, petItemId: String) -> AnyPublisher<Void, NetworkError> {
        struct EmptyResponse: Decodable {}
        return networkManager.requestWithPublisher(
            endpoint: PetEndpoint.petItemInteraction(petId: petId, petItemId: petItemId),
            responseType: EmptyResponse.self
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }

    func petItemInteractionWithResponsePublisher(petId: String, petItemId: String) -> AnyPublisher<PetItemInteractionResponse, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: PetEndpoint.petItemInteraction(petId: petId, petItemId: petItemId),
            responseType: PetItemInteractionResponse.self
        )
    }

    func deletePetPublisher(id: String) -> AnyPublisher<Void, NetworkError> {
        struct EmptyResponse: Decodable {}
        return networkManager.requestWithPublisher(
            endpoint: PetEndpoint.deletePet(id: id),
            responseType: EmptyResponse.self
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }

    func changePetNamePublisher(petId: String, petName: String, petCalling: String) -> AnyPublisher<ChangePetNameResponse, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: PetEndpoint.changePetName(petId: petId, petName: petName, petCalling: petCalling),
            responseType: ChangePetNameResponse.self
        )
    }
}

import Foundation
import Combine

// MARK: - Shop Endpoints
enum ShopEndpoint: Endpoint {
    case getAllShopItems
    case buyShopItem(itemId: String, mine: MineEnum)
    case buyPetItem(itemId: String, amount: Int, mine: MineEnum)
    case buyPackageItem(packageType: PackageType, packageId: String, mine: MineEnum?, petItemsWithAmounts: [PetItemWithAmount]?)

    var path: String {
        switch self {
        case .getAllShopItems:
            return "/shop/get-all-shop-items"
        case .buyShopItem:
            return "/shop/buy-item"
        case .buyPetItem:
            return "/pets/buy-pet-item"
        case .buyPackageItem:
            return "/package/buy-package-item"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAllShopItems:
            return .get
        case .buyShopItem, .buyPetItem, .buyPackageItem:
            return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getAllShopItems:
            return nil
        case .buyShopItem(let itemId, let mine):
            return [
                "itemId": itemId,
                "mine": mine.rawValue
            ]
        case .buyPetItem(let itemId, let amount, let mine):
            return [
                "petItemId": itemId,
                "amount": amount,
                "mine": mine.rawValue
            ]
        case .buyPackageItem(let packageType, let packageId, let mine, let petItemsWithAmounts):
            var params: [String: Any] = [
                "packageType": packageType.rawValue,
                "packageId": packageId
            ]

            switch packageType {
            case .eggPackage, .petPackage:
                if let mine = mine {
                    params["mine"] = mine.rawValue
                }
            case .petItemPackage:
                if let items = petItemsWithAmounts {
                    params["petItemsWithAmounts"] = items.map {
                        ["petItemId": $0.petItemId, "amount": $0.amount]
                    }
                }
            }

            return params
        }
    }

    var requiresAuthentication: Bool {
        return true
    }
}

// MARK: - Shop Repository Protocol
protocol ShopRepository: BaseRepository {
    func getAllShopItems() async throws -> GetAllShopItems
    func buyShopItem(itemId: String, mine: MineEnum) async throws
    func buyPetItem(itemId: String, amount: Int, mine: MineEnum) async throws
    func buyPackageItem(packageType: PackageType, packageId: String, mine: MineEnum?, petItemsWithAmounts: [PetItemWithAmount]?) async throws

    // Combine variants
    func getAllShopItemsPublisher() -> AnyPublisher<GetAllShopItems, NetworkError>
    func buyShopItemPublisher(itemId: String, mine: MineEnum) -> AnyPublisher<EmptyResponse, NetworkError>
    func buyPetItemPublisher(itemId: String, amount: Int, mine: MineEnum) -> AnyPublisher<EmptyResponse, NetworkError>
    func buyPackageItemPublisher(packageType: PackageType, packageId: String, mine: MineEnum?, petItemsWithAmounts: [PetItemWithAmount]?) -> AnyPublisher<EmptyResponse, NetworkError>
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

    func buyShopItem(itemId: String, mine: MineEnum) async throws {
        let _: EmptyResponse = try await networkManager.request(
            endpoint: ShopEndpoint.buyShopItem(itemId: itemId, mine: mine),
            responseType: EmptyResponse.self
        )
    }

    func buyPetItem(itemId: String, amount: Int, mine: MineEnum) async throws {
        let _: EmptyResponse = try await networkManager.request(
            endpoint: ShopEndpoint.buyPetItem(itemId: itemId, amount: amount, mine: mine),
            responseType: EmptyResponse.self
        )
    }

    func buyPackageItem(packageType: PackageType, packageId: String, mine: MineEnum? = nil, petItemsWithAmounts: [PetItemWithAmount]? = nil) async throws {
        let _: EmptyResponse = try await networkManager.request(
            endpoint: ShopEndpoint.buyPackageItem(
                packageType: packageType,
                packageId: packageId,
                mine: mine,
                petItemsWithAmounts: petItemsWithAmounts
            ),
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

    func buyShopItemPublisher(itemId: String, mine: MineEnum) -> AnyPublisher<EmptyResponse, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: ShopEndpoint.buyShopItem(itemId: itemId, mine: mine),
            responseType: EmptyResponse.self
        )
    }

    func buyPetItemPublisher(itemId: String, amount: Int, mine: MineEnum) -> AnyPublisher<EmptyResponse, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: ShopEndpoint.buyPetItem(itemId: itemId, amount: amount, mine: mine),
            responseType: EmptyResponse.self
        )
    }

    func buyPackageItemPublisher(packageType: PackageType, packageId: String, mine: MineEnum? = nil, petItemsWithAmounts: [PetItemWithAmount]? = nil) -> AnyPublisher<EmptyResponse, NetworkError> {
        return networkManager.requestWithPublisher(
            endpoint: ShopEndpoint.buyPackageItem(
                packageType: packageType,
                packageId: packageId,
                mine: mine,
                petItemsWithAmounts: petItemsWithAmounts
            ),
            responseType: EmptyResponse.self
        )
    }
}

// Helper types
struct EmptyResponse: Codable {
    let status: String?
}

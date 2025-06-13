//
//  ShopScreenViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 12.04.2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class ShopScreenViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var allItems: AllItems?

    private let shopRepository: ShopRepository
    private var cancellables = Set<AnyCancellable>()

    init(shopRepository: ShopRepository = ShopRepositoryImpl()) {
        self.shopRepository = shopRepository
    }

    func fetchAllShopItem(completion: @escaping () -> Void = {}) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await shopRepository.getAllShopItems()
                self.allItems = response.data
                self.isLoading = false
                completion()
            } catch let error as NetworkError {
                handleNetworkError(error)
                completion()
            } catch {
                self.errorMessage = "Error: \(error.localizedDescription)"
                self.isLoading = false
                completion()
            }
        }
    }

    func buyShopItem(itemId: String, mine: MineEnum, completion: (() -> Void)? = nil) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                try await shopRepository.buyShopItem(itemId: itemId, mine: mine)
                self.isLoading = false
                print("Item purchased successfully!")
                completion?()
            } catch let error as NetworkError {
                handleNetworkError(error)
                completion?()
            } catch {
                self.errorMessage = "Error: \(error.localizedDescription)"
                self.isLoading = false
                print("Purchase failed: \(error.localizedDescription)")
                completion?()
            }
        }
    }

    func buyPetItem(itemId: String, amount: Int, mine: MineEnum, completion: (() -> Void)? = nil) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                try await shopRepository.buyPetItem(itemId: itemId, amount: amount, mine: mine)
                self.isLoading = false
                completion?()
            } catch let error as NetworkError {
                handleNetworkError(error)
                completion?()
            } catch {
                self.errorMessage = "Error: \(error.localizedDescription)"
                self.isLoading = false
                print("Error detail: \(error)")
                completion?()
            }
        }
    }

    func buyPackageItem(packageType: PackageType, packageId: String, mine: MineEnum? = nil, petItemsWithAmounts: [PetItemWithAmount]? = nil, completion: (() -> Void)? = nil) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                try await shopRepository.buyPackageItem(
                    packageType: packageType,
                    packageId: packageId,
                    mine: mine,
                    petItemsWithAmounts: petItemsWithAmounts
                )
                self.isLoading = false
                print("Package purchased successfully!")
                completion?()
            } catch let error as NetworkError {
                handleNetworkError(error)
                completion?()
            } catch {
                self.errorMessage = "Error: \(error.localizedDescription)"
                self.isLoading = false
                print("Package purchase failed: \(error.localizedDescription)")
                completion?()
            }
        }
    }

    private func handleNetworkError(_ error: NetworkError) {
        switch error {
        case .serverError(let statusCode, let message):
            errorMessage = "Server error (\(statusCode)): \(message ?? "Unknown error")"
        case .unauthorized:
            errorMessage = "Unauthorized access. Please log in again."
        case .timeOut:
            errorMessage = "Request timed out. Please try again."
        default:
            errorMessage = "Network error: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

//
//  PetCareViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 5.05.2025.
//

import Foundation
import Combine

struct GroupedPetItem: Identifiable {
    let id: String
    let name: String
    let effectType: EffectType
    let totalQuantity: Int
    let item: InventoryItem
}

@MainActor
final class InventoryViewModel: ObservableObject {
    @Published var eggs: [InventoryItem] = []
    @Published var crackedEggs: [InventoryItem] = []
    @Published var pets: [Pet] = []
    @Published var petItems: [InventoryItem] = []
    @Published var selectedCategory: EffectType? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPet: Pet?

    // Repositories
    private let inventoryRepository: InventoryRepository
    private let petRepository: PetRepository
    
    // MARK: - Initialization
    init(
        inventoryRepository: InventoryRepository = RepositoryProvider.shared.inventoryRepository,
        petRepository: PetRepository = RepositoryProvider.shared.petRepository
    ) {
        self.inventoryRepository = inventoryRepository
        self.petRepository = petRepository
    }

    func fetchInventory() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await inventoryRepository.getInventory()
            let items = response.data.inventory.items
            
            eggs = items.filter {
                $0.itemType == .shopItem && $0.itemId.category == "eggs" && !($0.properties.egg?.isCrackedByUser ?? false)
            }
            
            crackedEggs = items.filter {
                $0.itemType == .shopItem && $0.itemId.category == "eggs" && ($0.properties.egg?.isCrackedByUser ?? false)
            }
            
            petItems = items.filter { $0.isPetItem }
        } catch let error as NetworkError {
            handleNetworkError(error)
        } catch {
            errorMessage = "Envanter yüklenemedi: \(error.localizedDescription)"
            print("Fetch inventory hatası: \(error)")
        }
    }

    func fetchPets() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await petRepository.getPets()
            pets = response.data.pets.filter { $0.isHatched && !$0.isDeleted }
        } catch let error as NetworkError {
            handleNetworkError(error)
        } catch {
            errorMessage = "Hayvanlar yüklenemedi: \(error.localizedDescription)"
            print("Fetch pets hatası: \(error)")
        }
    }

    func hatchPets(_ inventoryItemEggIds: [String]) async throws -> HatchPetsResponseModel {
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await inventoryRepository.hatchPets(inventoryItemEggIds: inventoryItemEggIds)
            return response
        } catch {
            throw error
        }
    }
    
    func deletePet(petId: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await petRepository.deletePet(id: petId)
            await fetchPets()
        } catch let error as NetworkError {
            handleNetworkError(error)
            throw error
        } catch {
            errorMessage = "Pet silme başarısız: \(error.localizedDescription)"
            print("Delete pet hatası: \(error)")
            throw error
        }
    }
    
    func usePetItem(petId: String, petItemId: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await petRepository.petItemInteractionWithResponse(petId: petId, petItemId: petItemId)

            // Eğer data varsa güncelle, yoksa manuel fetch yap
            if let updatedPet = response.data?.pet {
                if let index = pets.firstIndex(where: { $0.id == updatedPet.id }) {
                    pets[index] = updatedPet
                }
                currentPet = updatedPet
            }
            
            if let updatedInventory = response.data?.inventory {
                petItems = updatedInventory.items.filter { $0.isPetItem }
            } else {
                // Data yoksa, manuel olarak inventory ve pets'i güncelle
                await fetchInventory()
                await fetchPets()
                // fetchPets sonrası currentPet'i güncelle
                if let updatedPet = pets.first(where: { $0.id == petId }) {
                    currentPet = updatedPet
                }
            }
            print("Pet item used successfully: \(response.message)")
        } catch let error as NetworkError {
            handleNetworkError(error)
        } catch {
            errorMessage = "Eşya kullanımı başarısız: \(error.localizedDescription)"
            print("Use pet item error: \(error)")
        }
    }

    // MARK: - Helper Methods
    func groupedPetItems() -> [GroupedPetItem] {
        let groupedItems = Dictionary(grouping: petItems, by: { $0.itemId.name })
        return groupedItems.map { name, items in
            let totalQuantity = items.reduce(0) { $0 + ($1.properties.quantity ?? 0) }
            let firstItem = items.first!
            return GroupedPetItem(
                id: firstItem.itemId.id,
                name: name,
                effectType: firstItem.itemId.effectType!,
                totalQuantity: totalQuantity,
                item: firstItem
            )
        }
        .filter { $0.totalQuantity > 0 }
        .sorted { $0.name < $1.name }
    }

    func filteredPetItems() -> [GroupedPetItem] {
        let grouped = groupedPetItems()
        if let category = selectedCategory {
            return grouped.filter { $0.effectType == category }
        }
        return grouped
    }
    
    // MARK: - Error Handling
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
    }
}

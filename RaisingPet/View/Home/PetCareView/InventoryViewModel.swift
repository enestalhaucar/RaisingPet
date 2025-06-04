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
    let isInInventory: Bool
    let effectAmount: Int?
}

@MainActor
final class InventoryViewModel: ObservableObject {
    @Published var eggs: [InventoryItem] = []
    @Published var crackedEggs: [InventoryItem] = []
    @Published var pets: [Pet] = []
    @Published var petItems: [InventoryItem] = []
    @Published var allShopPetItems: [PetItem] = []
    @Published var selectedCategory: EffectType? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPet: Pet?

    // Repositories
    private let inventoryRepository: InventoryRepository
    private let petRepository: PetRepository
    private let shopRepository: ShopRepository
    
    // MARK: - Initialization
    init(
        inventoryRepository: InventoryRepository = RepositoryProvider.shared.inventoryRepository,
        petRepository: PetRepository = RepositoryProvider.shared.petRepository,
        shopRepository: ShopRepository = RepositoryProvider.shared.shopRepository
    ) {
        self.inventoryRepository = inventoryRepository
        self.petRepository = petRepository
        self.shopRepository = shopRepository
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
            
            if allShopPetItems.isEmpty {
                await fetchAllShopItems()
            }
        } catch let error as NetworkError {
            handleNetworkError(error)
        } catch {
            errorMessage = "Envanter yüklenemedi: \(error.localizedDescription)"
            print("Fetch inventory hatası: \(error)")
        }
    }
    
    func fetchAllShopItems() async {
        do {
            let response = try await shopRepository.getAllShopItems()
            allShopPetItems = response.data.petItems
            print("Fetched \(allShopPetItems.count) pet items from shop")
        } catch let error as NetworkError {
            handleNetworkError(error)
        } catch {
            errorMessage = "Shop itemleri yüklenemedi: \(error.localizedDescription)"
            print("Fetch shop items error: \(error)")
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

            if let updatedPet = response.data?.pet {
                if let index = pets.firstIndex(where: { $0.id == updatedPet.id }) {
                    pets[index] = updatedPet
                }
                currentPet = updatedPet
            }
            
            if let updatedInventory = response.data?.inventory {
                petItems = updatedInventory.items.filter { $0.isPetItem }
            } else {
                await fetchInventory()
                await fetchPets()
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
    
    func changePetName(petId: String, petName: String, petCalling: String) async throws {
        do {
            let response = try await petRepository.changePetName(petId: petId, petName: petName, petCalling: petCalling)
            
            // Güncellenmiş pet verilerini al
            let updatedPet = response.data.pet
            // pets listesinde güncelle
            if let index = pets.firstIndex(where: { $0.id == updatedPet.id }) {
                pets[index] = updatedPet
            }
            // current pet'i güncelle
            currentPet = updatedPet
            print("🐾 Pet name changed successfully: \(updatedPet.petName ?? ""), calling: \(updatedPet.petCalling ?? "")")
        } catch let error as NetworkError {
            handleNetworkError(error)
            print("❌ Change pet name network error: \(error)")
            throw error
        } catch {
            errorMessage = "Pet ismi değiştirme başarısız: \(error.localizedDescription)"
            print("❌ Change pet name error: \(error)")
            throw error
        }
    }

    // MARK: - Helper Methods
    func getAllPetItems() -> [GroupedPetItem] {
        var inventoryItemsById: [String: InventoryItem] = [:]
        var inventoryQuantities: [String: Int] = [:]
        
        for item in petItems {
            let id = item.itemId.id
            inventoryItemsById[id] = item
            inventoryQuantities[id] = item.properties.quantity ?? 0
        }
        
        var result: [GroupedPetItem] = []
        
        for shopItem in allShopPetItems {
            if let id = shopItem.id, 
               let effectTypeStr = shopItem.effectType, 
               let effectTypeEnum = EffectType(rawValue: effectTypeStr) {
                
                let quantity = inventoryQuantities[id] ?? 0
                let isInInventory = quantity > 0
                
                if let inventoryItem = inventoryItemsById[id] {
                    result.append(GroupedPetItem(
                        id: id,
                        name: shopItem.name ?? "",
                        effectType: effectTypeEnum,
                        totalQuantity: quantity,
                        item: inventoryItem,
                        isInInventory: true,
                        effectAmount: shopItem.effectAmount
                    ))
                } else {
                    let syntheticItem = createSyntheticInventoryItem(from: shopItem)
                    result.append(GroupedPetItem(
                        id: id,
                        name: shopItem.name ?? "",
                        effectType: effectTypeEnum,
                        totalQuantity: 0,
                        item: syntheticItem,
                        isInInventory: false,
                        effectAmount: shopItem.effectAmount
                    ))
                }
            }
        }
        
        return result.sorted { $0.name < $1.name }
    }
    
    private func createSyntheticInventoryItem(from shopItem: PetItem) -> InventoryItem {
        let itemId = shopItem.id ?? ""
        let itemName = shopItem.name ?? ""
        let isItemDeleted = shopItem.isDeleted ?? false
        let itemVersion = shopItem.v ?? 0
        
        var effectTypeEnum: EffectType? = nil
        if let effectTypeStr = shopItem.effectType {
            effectTypeEnum = EffectType(rawValue: effectTypeStr)
        }
        
        var barAffectedEnum: BarAffected? = nil
        if let barAffectedStr = shopItem.barAffected {
            barAffectedEnum = BarAffected(rawValue: barAffectedStr)
        }
        
        var currencyTypeEnum: CurrencyType? = nil
        if let currencyType = shopItem.currencyType {
            currencyTypeEnum = CurrencyType(rawValue: currencyType.rawValue)
        }
        
        return InventoryItem(
            id: nil,
            itemType: .petItem,
            itemId: ItemDetail(
                id: itemId,
                name: itemName,
                description: shopItem.description,
                category: nil,
                isDeleted: isItemDeleted,
                version: itemVersion,
                effectAmount: shopItem.effectAmount,
                effectType: effectTypeEnum,
                barAffected: barAffectedEnum,
                diamondPrice: shopItem.diamondPrice,
                goldPrice: shopItem.goldPrice,
                currencyType: currencyTypeEnum,
                idAlias: nil
            ),
            acquiredAt: nil,
            properties: ItemProperties(
                egg: nil,
                quantity: 0,
                isOwned: false
            )
        )
    }
    
    func filteredPetItems() -> [GroupedPetItem] {
        let allItems = getAllPetItems()
        if let category = selectedCategory {
            return allItems.filter { $0.effectType == category }
        }
        return allItems
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

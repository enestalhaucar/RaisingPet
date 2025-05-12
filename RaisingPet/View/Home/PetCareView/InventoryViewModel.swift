//
//  PetCareViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 5.05.2025.
//

import Foundation
import Alamofire

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

    private let inventoryURL = Utilities.Constants.Endpoints.Inventory.myInventory
    private let hatchURL = Utilities.Constants.Endpoints.Inventory.hatchPets
    private let petsURL = Utilities.Constants.Endpoints.Pets.getPets
    private let deletePetURL = Utilities.Constants.Endpoints.Pets.deletePet
    private let petItemInteractionURL = Utilities.Constants.Endpoints.Pets.petItemInteraction

    private var headers: HTTPHeaders {
        let token = Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? ""
        return [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
    }

    func fetchInventory() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        do {
            let resp = try await AF.request(inventoryURL,
                                            method: .get,
                                            headers: headers)
                .validate()
                .serializingDecodable(GetInventoryResponse.self, decoder: decoder)
                .value

            let items = resp.data.inventory.items
            eggs = items.filter {
                $0.itemType == .shopItem && $0.itemId.category == "eggs" && !($0.properties.egg?.isCrackedByUser ?? false)
            }
            crackedEggs = items.filter {
                $0.itemType == .shopItem && $0.itemId.category == "eggs" && ($0.properties.egg?.isCrackedByUser ?? false)
            }
            petItems = items.filter { $0.isPetItem }
        } catch {
            errorMessage = "Envanter yüklenemedi: \(error.localizedDescription)"
            print("Fetch inventory hatası: \(error)")
        }
    }

    func fetchPets() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        do {
            let resp = try await AF.request(petsURL,
                                            method: .get,
                                            headers: headers)
                .validate()
                .serializingDecodable(GetPetsResponse.self, decoder: decoder)
                .value

            pets = resp.data.pets.filter { $0.isHatched && !$0.isDeleted }
        } catch {
            errorMessage = "Hayvanlar yüklenemedi: \(error.localizedDescription)"
            print("Fetch pets hatası: \(error)")
        }
    }

    func hatchPets(_ inventoryItemEggIds: [String]) async throws -> HatchPetsResponse {
        isLoading = true
        defer { isLoading = false }

        let params: [String: Any] = ["inventoryItemEggIds": inventoryItemEggIds]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        do {
            let response = try await AF.request(hatchURL,
                                                method: .post,
                                                parameters: params,
                                                encoding: JSONEncoding.default,
                                                headers: headers)
                .validate()
                .serializingDecodable(HatchPetsResponse.self, decoder: decoder)
                .value
            return response
        } catch {
            throw error
        }
    }
    
    func deletePet(petId: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = deletePetURL.replacingOccurrences(of: ":id", with: petId)

        do {
            let response = try await AF.request(url,
                                                method: .get,
                                                headers: headers)
                .validate()

            if let httpResponse = response.response, httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                await fetchPets()
            } else {
                throw AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: response.response?.statusCode ?? 500))
            }
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

        let params: [String: Any] = ["petId": petId, "petItemId": petItemId]
        
        do {
            let response = try await AF.request(petItemInteractionURL,
                                               method: .post,
                                               parameters: params,
                                               encoding: JSONEncoding.default,
                                               headers: headers)
                .validate()
                .serializingDecodable(PetItemInteractionResponse.self)
                .value

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
                // Data yoksa, manuel olarak inventory ve pets’i güncelle
                await fetchInventory()
                await fetchPets()
                // fetchPets sonrası currentPet’i güncelle
                if let updatedPet = pets.first(where: { $0.id == petId }) {
                    currentPet = updatedPet
                }
            }
            print("Pet item used successfully: \(response.message)")
        } catch {
            errorMessage = "Eşya kullanımı başarısız: \(error.localizedDescription)"
            print("Use pet item error: \(error)")
        }
    }

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
}

struct PetItemInteractionResponse: Codable {
    let status: String
    let message: String
    let data: PetItemInteractionData?
}

struct PetItemInteractionData: Codable {
    let pet: Pet?
    let inventory: Inventory?
}

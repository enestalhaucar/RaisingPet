//
//  PetCareViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 5.05.2025.
//

import Foundation
import Alamofire

// Gruplanmış PetItem için yeni struct
struct GroupedPetItem: Identifiable {
    let id: String // itemId._id
    let name: String
    let effectType: EffectType
    let totalQuantity: Int
    let item: InventoryItem // Orjinal item'dan bir örnek
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

    private let inventoryURL = Utilities.Constants.Endpoints.Inventory.myInventory
    private let hatchURL = Utilities.Constants.Endpoints.Inventory.hatchPets
    private let petsURL = Utilities.Constants.Endpoints.Pets.getPets
    private let deletePetURL = Utilities.Constants.Endpoints.Pets.deletePet

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

            let url = deletePetURL.replacingOccurrences(of: ":id", with: petId) // Dinamik :id ile URL oluştur

            do {
                let response = try await AF.request(url,
                                                    method: .get,
                                                    headers: headers)
                    .validate()


                if let httpResponse = response.response, httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                    // 200 veya 204 ile başarı kabul edilir
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
    
    func groupedPetItems() -> [GroupedPetItem] {
        // Aynı isimdeki item'ları grupla
        let groupedItems = Dictionary(grouping: petItems, by: { $0.itemId.name })
        
        return groupedItems.map { name, items in
            let totalQuantity = items.reduce(0) { $0 + ($1.properties.quantity ?? 0) }
            let firstItem = items.first! // En az bir item var
            return GroupedPetItem(
                id: firstItem.itemId.id,
                name: name,
                effectType: firstItem.itemId.effectType!,
                totalQuantity: totalQuantity,
                item: firstItem
            )
        }
        .filter { $0.totalQuantity > 0 } // quantity 0 olanları gizle
        .sorted { $0.name < $1.name } // İsim sırasına göre sırala
    }

    func filteredPetItems() -> [GroupedPetItem] {
        let grouped = groupedPetItems()
        if let category = selectedCategory {
            return grouped.filter { $0.effectType == category }
        }
        return grouped
    }
}

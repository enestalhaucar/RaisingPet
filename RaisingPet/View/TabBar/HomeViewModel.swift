//
//  HomeViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 20.06.2024.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var petToDisplay: Pet?
    @Published private(set) var eggToDisplay: InventoryItem?
    @Published private(set) var isLoading: Bool = true
    @Published var errorMessage: String?

    // MARK: - Repositories
    private let petsRepository: PetRepository
    private let inventoryRepository: InventoryRepository

    // MARK: - Initialization
    init(
        petsRepository: PetRepository = RepositoryProvider.shared.petRepository,
        inventoryRepository: InventoryRepository = RepositoryProvider.shared.inventoryRepository
    ) {
        self.petsRepository = petsRepository
        self.inventoryRepository = inventoryRepository
    }

    // MARK: - Data Fetching
    func fetchInitialData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Önce kullanıcının hayvanlarını çekmeyi dene.
            let petsResponse = try await petsRepository.getPets()
            if let firstPet = petsResponse.data.pets.first {
                // Eğer hayvan varsa, onu göster ve işlemi bitir.
                self.petToDisplay = firstPet
                self.isLoading = false
                return
            }
            
            // 2. Eğer hayvan yoksa, envanteri (yumurtaları) kontrol et.
            let inventoryResponse = try await inventoryRepository.getInventory()
            let eggs = inventoryResponse.data.inventory.items.filter { $0.itemType == .petItem && $0.properties.egg != nil }
            
            if let firstEgg = eggs.first {
                // Eğer yumurta varsa, onu göster.
                self.eggToDisplay = firstEgg
            } else {
                // Yumurta da yoksa, her iki gösterilecek öğe de nil olacak.
                self.eggToDisplay = nil
            }
            
        } catch let error as NetworkError {
            self.errorMessage = "Veri alınamadı: \(error.localizedDescription)"
            print("HomeViewModel fetch error: \(error)")
        } catch {
            self.errorMessage = "Beklenmedik bir hata oluştu: \(error.localizedDescription)"
            print("HomeViewModel generic error: \(error)")
        }
        
        isLoading = false
    }
} 

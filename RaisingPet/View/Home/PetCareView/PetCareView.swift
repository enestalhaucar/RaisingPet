//
//  PetCareView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 4.09.2024.
//

import SwiftUI

struct PetCareView: View {
    let pet: Pet
    @StateObject private var vm = InventoryViewModel()
    @State private var deletePetShow: Bool = false
    @State private var selectedTab: Int = 0
    @State private var showEditPopup = false
    @Environment(\.dismiss) var dismiss
    
    // Pet name göster - eğer petName varsa onu, yoksa petType.name'i göster
    private var displayPetName: String {
        return pet.petName?.isEmpty == false ? pet.petName! : pet.petType.name.capitalized
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    PetHeaderView(pet: pet, selectedTab: $selectedTab, vm: vm, showEditPopup: $showEditPopup)
                    PetItemGridView(vm: vm)
                }
                if deletePetShow {
                    PetDeleteAlertView(pet: pet, isPresented: $deletePetShow)
                        .environmentObject(vm) // ViewModel'ı PetDeleteAlertView'a aktar
                }
                
                // Pet Name Edit Popup
                if showEditPopup {
                    PetNameEditPopupView(
                        isPresented: $showEditPopup,
                        pet: pet,
                        onSave: { newName, newCalling in
                            handlePetNameUpdate(name: newName, calling: newCalling)
                        }
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        deletePetShow = true
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(Color.orange)
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        showEditPopup = true
                    }) {
                        HStack(spacing: 4) {
                            Text(displayPetName)
                                .font(.nunito(.bold, .headline17))
                                .foregroundColor(.primary)
                            Image(systemName: "pencil")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            .task {
                // Fetch inventory and all shop items in parallel
                async let inventoryTask: () = vm.fetchInventory()
                async let petsTask: () = vm.fetchPets()
                async let shopItemsTask: () = vm.fetchAllShopItems()
                
                // Wait for all tasks to complete
                _ = await [inventoryTask, petsTask, shopItemsTask]
                
                // Set current pet and initial category
                vm.currentPet = pet
                vm.selectedCategory = .funMaterial
                selectedTab = 0
            }
            .environmentObject(vm) // ViewModel'ı tüm alt view'lara aktar
        }
    }
    
    // Pet name ve calling güncelleme işlemi
    private func handlePetNameUpdate(name: String, calling: String) {
        Task {
            do {
                try await vm.changePetName(petId: pet.id, petName: name, petCalling: calling)
                print("🐾 Pet name updated successfully")
            } catch {
                print("❌ Failed to update pet name: \(error)")
                // TODO: Kullanıcıya hata mesajı göster
            }
        }
    }
}

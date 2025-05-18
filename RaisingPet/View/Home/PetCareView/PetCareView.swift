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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    PetHeaderView(pet: pet, selectedTab: $selectedTab, vm: vm)
                    PetItemGridView(vm: vm)
                }
                if deletePetShow {
                    PetDeleteAlertView(pet: pet, isPresented: $deletePetShow)
                        .environmentObject(vm) // ViewModel'ı PetDeleteAlertView'a aktar
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
            .navigationTitle(pet.petType.name.capitalized)
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
}

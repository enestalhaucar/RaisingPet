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
                await vm.fetchInventory()
                await vm.fetchPets() // Pets verisini de çekelim
                vm.currentPet = pet // Current pet'i ayarla
                vm.selectedCategory = .funMaterial
                selectedTab = 0
            }
            .environmentObject(vm) // ViewModel'ı tüm alt view'lara aktar
        }
    }
}

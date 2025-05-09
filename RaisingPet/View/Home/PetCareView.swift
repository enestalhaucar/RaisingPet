//
//  PetCareView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 4.09.2024.
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
                        .environmentObject(vm) // ViewModel'ı aktar
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
                vm.selectedCategory = .funMaterial
                selectedTab = 0
            }
        }
    }
}

#Preview {
    PetCareView(pet: Pet(
        id: "681b90cdbd5d08c71c6c6859",
        ownerId: "68191ca3bd5d08c71c6bfadd",
        petType: PetType(
            id: "67fa53e58c1037768903c12a",
            rarity: Rarity(id: "67fa52d58c1037768903c118", rarityName: "common", weight: 50, isDeleted: false, version: 0),
            name: "duck",
            isDeleted: false,
            version: 0
        ),
        hunger: 100,
        thirst: 100,
        hygiene: 100,
        fun: 100,
        isHatched: true,
        isDeleted: false,
        petHistory: PetHistory(id: "681b90cdbd5d08c71c6c685a", petId: "681b90cdbd5d08c71c6c6859", actions: [], isDeleted: false, version: 0),
        version: 0,
        hatchedAt: "2025-05-07T16:56:58.777Z",
        nextBarUpdate: "2025-05-08T16:56:58.777Z",
        isHatchedByThisEgg: nil
    ))
}

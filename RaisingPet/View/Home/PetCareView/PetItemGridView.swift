//
//  PetItemGridView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

import SwiftUI

struct PetItemGridView: View {
    @ObservedObject var vm: InventoryViewModel
// SElam
    var body: some View {
        ScrollView {
            ZStack {
                Color.white.opacity(0.95)
                    .ignoresSafeArea()
                VStack {
                    if vm.filteredPetItems().isEmpty {
                        NavigationLink(destination: ShopScreenView()) {
                            Text("pet_item_grid_no_items".localized())
                                .font(.title3)
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                            ForEach(vm.filteredPetItems()) { groupedItem in
                                PetItemView(groupedItem: groupedItem)
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                }
            }
            .background(Color.white)
        }
        .frame(height: UIScreen.main.bounds.height * 0.6)
        .environmentObject(vm) // InventoryViewModel’ı alt view’lara geçir
    }
}

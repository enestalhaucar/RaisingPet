//
//  PetItemGridView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

import SwiftUI

struct PetItemGridView: View {
    @ObservedObject var vm: InventoryViewModel
    @State private var isRefreshing = false

    var body: some View {
        ScrollView {
            ZStack {
                Color.white.opacity(0.95)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if vm.filteredPetItems().isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "tray.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray.opacity(0.7))
                            
                            Text("pet_item_grid_no_items".localized())
                                .font(.nunito(.medium, .body16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            
                            NavigationLink(destination: ShopScreenView()) {
                                HStack {
                                    Image(systemName: "cart.fill")
                                    Text("pet_item_grid_shop_button".localized())
                                }
                                .font(.nunito(.semiBold, .body16))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.8))
                                        .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                                )
                            }
                        }
                        .padding(.vertical, 40)
                    } else {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
                            spacing: 16
                        ) {
                            ForEach(vm.filteredPetItems()) { groupedItem in
                                PetItemView(groupedItem: groupedItem)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                }
            }
            .background(Color.white)
        }
        .frame(height: UIScreen.main.bounds.height * 0.6)
        .environmentObject(vm)
        .refreshable {
            isRefreshing = true
            await vm.fetchInventory()
            isRefreshing = false
        }
    }
}

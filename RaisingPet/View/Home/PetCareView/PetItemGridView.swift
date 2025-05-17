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
                            
                            Text("Bu kategoride herhangi bir eşya bulunamadı.")
                                .font(.nunito(.medium, .body16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
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

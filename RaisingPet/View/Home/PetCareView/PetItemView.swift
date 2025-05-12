//
//  PetItemView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

import SwiftUI

struct PetItemView: View {
    let groupedItem: GroupedPetItem
    @EnvironmentObject var vm: InventoryViewModel
    @State private var isUsing = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .shadow(radius: 4)
                // Asset’ten görsel çek, yoksa sistem ikonu placeholder
                Image("\(groupedItem.name)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.indigo)
            }
            Text(groupedItem.name.capitalized)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
            Text("x\(groupedItem.totalQuantity)")
                .font(.caption2)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.indigo.opacity(0.6))
                .clipShape(Capsule())
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isUsing = true
                }
                Task {
                    await vm.usePetItem(petId: vm.currentPet?.id ?? "", petItemId: groupedItem.id)
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isUsing = false
                    }
                }
            }) {
                Text("pet_item_use_button".localized())
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(isUsing ? Color.gray.opacity(0.7) : Color.green.opacity(0.7))
                    .cornerRadius(10)
            }
            .disabled(groupedItem.totalQuantity == 0 || isUsing)
            .opacity(groupedItem.totalQuantity == 0 ? 0.5 : 1)
        }
        .frame(width: 100, height: 140)
        .padding(10)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        .scaleEffect(groupedItem.totalQuantity > 0 ? 1 : 0.95)
        .opacity(groupedItem.totalQuantity > 0 ? 1 : 0.5)
        .transition(.opacity.combined(with: .scale))
    }
}

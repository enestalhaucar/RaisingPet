//
//  PetItemView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

import SwiftUI

struct PetItemView: View {
    let groupedItem: GroupedPetItem

    private var itemImageName: String {
        switch groupedItem.name.lowercased() {
        case "soup", "meat", "fruit", "dessert", "vegetable", "nuts": return "fork.knife"
        case "cola", "water", "milk", "cocktail", "fruit juice", "coffee": return "drop.fill"
        case "normal soap", "wet wipe", "sponge", "rainbow soap", "perfume", "toilet paper": return "soap.fill"
        case "love", "rope", "trampoline", "music", "ball", "rattle": return "heart.circle.fill"
        default: return "questionmark.square.fill"
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .shadow(radius: 4)
                Image(systemName: itemImageName)
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
                // Şimdilik boş, ileride servis eklenecek
            }) {
                Text("Kullan")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.7))
                    .cornerRadius(10)
            }
            .disabled(groupedItem.totalQuantity == 0)
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

#Preview {
    PetItemView(groupedItem: GroupedPetItem(
        id: "67fa5e6cc335521510894ac7",
        name: "soup",
        effectType: .edibleMaterial,
        totalQuantity: 3,
        item: InventoryItem(
            id: "67fa5e6cc335521510894ac7",
            itemType: .petItem,
            itemId: ItemDetail(
                id: "67fa5e6cc335521510894ac7",
                name: "soup",
                description: "xxx",
                category: nil,
                isDeleted: false,
                version: 0,
                effectAmount: 50,
                effectType: .edibleMaterial,
                barAffected: .hunger,
                diamondPrice: 20,
                goldPrice: 200,
                currencyType: .both,
                idAlias: nil
            ),
            acquiredAt: nil,
            properties: ItemProperties(egg: nil, quantity: 3, isOwned: nil)
        )
    ))
}

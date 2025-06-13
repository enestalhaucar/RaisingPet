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
    @State private var isPressed = false

    // Yüksek etkili item kontrolü (50 veya daha yüksek)
    private var isHighEffect: Bool {
        return (groupedItem.effectAmount ?? 0) >= 50
    }

    // Item kullanılabilir mi? (envanterimizde var mı?)
    private var isUsable: Bool {
        return groupedItem.isInInventory && groupedItem.totalQuantity > 0
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Ana arka plan - ekran görüntüsüne benzer açık yeşil tint
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(red: 0.85, green: 0.95, blue: 0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(isUsable ? Color.green : Color.gray.opacity(0.3), lineWidth: isUsable ? 2 : 1)
                )

            VStack(spacing: 6) {
                HStack {
                    // Miktar etiketi
                    Text("x\(groupedItem.totalQuantity)")
                        .font(.nunito(.bold, .caption211))
                        .foregroundColor(.black)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.leading, 8)

                    Spacer()

                    // Yüksek etkili ürünler için yıldız badge (ekran görüntüsünde olduğu gibi)
                    if isHighEffect {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                            .shadow(color: .orange, radius: 1)
                            .padding(.trailing, 8)
                    }
                }

                // Item görseli
                Image("\(groupedItem.name)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .padding(.top, 2)
                    .saturation(isUsable ? 1.0 : 0.5)

                // Item adı
                Text(groupedItem.name.capitalized)
                    .font(.nunito(.medium, .callout14))
                    .foregroundColor(isUsable ? .black : .gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(isUsable ? 1.0 : 0.8)
        }
        .frame(width: 95, height: 110)
        .contentShape(RoundedRectangle(cornerRadius: 18))
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            guard isUsable, !isUsing else { return }
            withAnimation { isPressed = true }
            isUsing = true
            Task {
                await vm.usePetItem(petId: vm.currentPet?.id ?? "", petItemId: groupedItem.id)
                isUsing = false
                withAnimation { isPressed = false }
            }
        }
    }
}

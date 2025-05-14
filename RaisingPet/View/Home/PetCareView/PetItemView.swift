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

    var body: some View {
        ZStack(alignment: .top) {
            // Sarı, opaklığı düşük arka plan
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.yellow.opacity(0.18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
                )

            VStack(spacing: 6) {
                // Miktar etiketi üstte, ortalanmış
                HStack {
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
                }
                
                // Fotoğraf
                Image("\(groupedItem.name)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .padding(.top, 2)
                // İsim
                Text(groupedItem.name.capitalized)
                    .font(.nunito(.medium, .callout14))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

           
        }
        .frame(width: 95, height: 110)
        .contentShape(RoundedRectangle(cornerRadius: 18))
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            guard groupedItem.totalQuantity > 0, !isUsing else { return }
            withAnimation { isPressed = true }
            isUsing = true
            Task {
                await vm.usePetItem(petId: vm.currentPet?.id ?? "", petItemId: groupedItem.id)
                isUsing = false
                withAnimation { isPressed = false }
            }
        }
        .opacity(groupedItem.totalQuantity > 0 ? 1 : 0.5)
    }
}

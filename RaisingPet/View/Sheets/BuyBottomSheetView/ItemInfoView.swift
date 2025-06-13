//
//  ItemInfoView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 13.06.2025.
//

import SwiftUI

// MARK: - Item Info View
struct ItemInfoView: View {
    let item: ShopItem
    @Binding var showCounter: Bool
    @Binding var counterNumber: Int

    var body: some View {
        HStack {
            ItemImageView(imageName: item.name ?? "egg")
            if showCounter {
                Spacer()
                BuyCounterView(counterNumber: $counterNumber).minimumScaleFactor(0.8)
            } else {
                DescriptionOfItemView(item: item)
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(RoundedRectangle(cornerRadius: 15).fill(.yellow.opacity(0.05)))
        .padding(.horizontal, 20)
    }
}

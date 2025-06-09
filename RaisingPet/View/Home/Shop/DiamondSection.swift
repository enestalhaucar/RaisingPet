//
//  DiamondSection.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//

import SwiftUI

struct DiamondSection: View {
    let items: [ShopItem]
    let onSelect: (ShopItem) -> Void

    var body: some View {
        ThreeColumnGrid(items: items.filter { $0.category == .gameCurrencyDiamond },
                        id: \.id) { item in
            ShopItemView(
                imageName: item.name ?? "diamondPlaceholder",
                goldCost: item.goldPrice,
                diamondCost: item.diamondPrice,
                price: item.price.map { "$\($0)" }
            ) {
                onSelect(item)
            }
        }
    }
}

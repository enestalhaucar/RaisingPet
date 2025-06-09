//
//  EggSingleSection.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//
import SwiftUI

struct EggSingleSection: View {
    let items: [ShopItem]
    let onSelect: (ShopItem) -> Void

    var body: some View {
        SectionHeader(title: "shop_section_single_eggs")
        ThreeColumnGrid(items: items.filter { $0.category == .eggs },
                        id: \.id) { item in
            ShopItemView(
                imageName: item.name ?? "eggPlaceholder",
                goldCost: item.goldPrice,
                diamondCost: item.diamondPrice,
                price: nil
            ) {
                onSelect(item)
            }
        }
    }
}

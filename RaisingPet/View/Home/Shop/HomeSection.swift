//
//  HomeSection.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//
import SwiftUI

struct HomeSection: View {
    let items: [ShopItem]
    let onSelect: (ShopItem) -> Void

    var body: some View {
        SectionHeader(title: "shop_section_home_items")
        ThreeColumnGrid(items: items.filter { $0.category == .home },
                        id: \.id) { item in
            ShopItemView(
                imageName: item.name ?? "homeIcon",
                goldCost: item.goldPrice,
                diamondCost: item.diamondPrice,
                price: nil
            ) {
                onSelect(item)
            }
        }
    }
}

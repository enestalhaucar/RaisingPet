//
//  EggPackageSection.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//

import SwiftUI

struct EggPackageSection: View {
    let eggs: [EggPackage]
    let onSelect: (ShopItem) -> Void

    var body: some View {
        SectionHeader(title: "shop_section_egg_packages")
        ThreeColumnGrid(items: eggs, id: \.id) { egg in
            ShopItemView(
                imageName: egg.name ?? "eggPlaceholder",
                goldCost: egg.goldPrice,
                diamondCost: egg.diamondPrice,
                price: nil
            ) {
                let shopItem = ShopItem(
                    id: egg.id,
                    name: egg.name,
                    description: egg.description,
                    category: .eggs,
                    isDeleted: egg.isDeleted,
                    v: egg.v,
                    duration: egg.eggType?.duration,
                    isPurchasable: true,
                    diamondPrice: egg.diamondPrice,
                    goldPrice: egg.goldPrice,
                    quantity: egg.amount,
                    price: nil,
                    isOwned: false
                )
                onSelect(shopItem)
            }
        }
    }
}

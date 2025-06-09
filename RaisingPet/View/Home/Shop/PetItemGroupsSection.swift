//
//  PetItemGroupsSection.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//
import SwiftUI

struct PetItemGroupsSection: View {
    let petItems: [PetItem]
    let onSelect: (ShopItem) -> Void

    private let allGroups: [(title: String, key: String)] = [
        ("shop_group_edible".localized(),    "edibleMaterial"),
        ("shop_group_drinkable".localized(), "drinkableMaterial"),
        ("shop_group_cleaning".localized(),  "cleaningMaterial"),
        ("shop_group_fun".localized(),       "funMaterial")
    ]

    private var nonEmptyGroups: [(title: String, key: String)] {
        allGroups.filter { group in
            petItems.contains { $0.effectType == group.key }
        }
    }

    var body: some View {
        ForEach(nonEmptyGroups, id: \.key) { section in
            let filtered = petItems.filter { $0.effectType == section.key }

            SectionHeader(title: section.title)

            ThreeColumnGrid(items: filtered, id: \.id) { pet in
                ShopItemView(
                    imageName: pet.name ?? "foodIcon",
                    goldCost:   pet.goldPrice,
                    diamondCost: pet.diamondPrice,
                    price:      nil
                ) {
                    onSelect(pet.toShopItem())
                }
            }
        }
    }
}

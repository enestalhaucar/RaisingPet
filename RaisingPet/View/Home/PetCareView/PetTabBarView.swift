//
//  PetTabBarView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

import SwiftUI

struct PetTabBarView: View {
    @Binding var selectedTab: Int
    @ObservedObject var vm: InventoryViewModel
    private let categories: [EffectType] = [.funMaterial, .edibleMaterial, .drinkableMaterial, .cleaningMaterial]
    private let tabIcons: [String] = ["smileyIcon", "foodIcon", "waterIcon", "bathIcon", "toiletIcon"]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<5) { index in
                Button(action: {
                    if index < 4 {
                        vm.selectedCategory = categories[index]
                        selectedTab = index
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 44, height: 44)
                            .foregroundStyle(selectedTab == index ? .yellow : .gray.opacity(0.3))
                        Image(tabIcons[index])
                            .foregroundColor(.black)
                    }
                }
                .disabled(index == 4)
                .overlay(index == 4 ? Text("🚧").font(.caption) : nil)
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    PetTabBarView(selectedTab: .constant(0), vm: InventoryViewModel())
}

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
    private let tabIcons: [String] = ["smileyIcon", "foodIcon", "waterIcon", "bathIcon"]
    private let fillColor: Color = .green.opacity(0.7)

    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<4) { index in // 0..<5 yerine 0..<4 yaparak 5. butonu kaldırdık
                Button(action: {
                    vm.selectedCategory = categories[index]
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    ZStack {
                        // Arka plan: Tek bir grimsi RoundedRectangle
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.gray.opacity(0.3))
                            .frame(width: 44, height: 44)

                        // Dolu kısım: Alttan yukarı dolacak
                        if let pet = vm.currentPet {
                            let value = getBarValue(index: index, pet: pet)
                            RoundedRectangle(cornerRadius: 15)
                                .fill(fillColor)
                                .frame(width: 44, height: 44 * (value / 100))
                                .offset(y: 22 * (1 - value / 100))
                                .animation(.easeInOut(duration: 0.5), value: value)
                        }

                        // Üstteki ikon
                        Image(tabIcons[index])
                            .foregroundColor(.black)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(selectedTab == index ? fillColor : .clear, lineWidth: 2)
                    )
                }
            }
        }
        .padding(.top, 10)
    }

    private func getBarValue(index: Int, pet: Pet) -> Double {
        switch index {
        case 0: return Double(pet.fun)
        case 1: return Double(pet.hunger)
        case 2: return Double(pet.thirst)
        case 3: return Double(pet.hygiene)
        default: return 0
        }
    }
}

#Preview {
    PetTabBarView(selectedTab: .constant(0), vm: InventoryViewModel())
}


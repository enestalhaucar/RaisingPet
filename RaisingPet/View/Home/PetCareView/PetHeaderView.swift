//
//  PetHeaderView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

import SwiftUI

struct PetHeaderView: View {
    let pet: Pet
    @Binding var selectedTab: Int
    @ObservedObject var vm: InventoryViewModel
    private var petImageName: String {
        switch pet.petType.name.lowercased() {
        case "dog": return "dog.fill"
        case "cat": return "cat.fill"
        case "duck": return "bird.fill"
        case "frog": return "tortoise.fill"
        case "fox": return "fox.fill"
        case "panda": return "panda.fill"
        default: return "pawprint.fill"
        }
    }

    var body: some View {
        ZStack {
            Image("petCareViewBg")
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.main.bounds.height * 0.4) // 10'da 4
                .clipped()
            VStack(spacing: 0) {
                Spacer()
                    
                HStack {
                    VStack(spacing: 20) {
                        Image("historyIcon")
                        NavigationLink(destination: ShopScreenView()) {
                            Image("shopIcon")
                        }
                    }
                    Spacer()
                    Image(systemName: petImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    Spacer()
                    VStack(spacing: 20) {
                        Image("LuckyDraw")
                        Image("DormIcon")
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
                PetTabBarView(selectedTab: $selectedTab, vm: vm)
                    .padding(.bottom, 10)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.4)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    PetHeaderView(pet: Pet(
        id: "681b90cdbd5d08c71c6c6859",
        ownerId: "68191ca3bd5d08c71c6bfadd",
        petType: PetType(
            id: "67fa53e58c1037768903c12a",
            rarity: Rarity(id: "67fa52d58c1037768903c118", rarityName: "common", weight: 50, isDeleted: false, version: 0),
            name: "duck",
            isDeleted: false,
            version: 0
        ),
        hunger: 100,
        thirst: 100,
        hygiene: 100,
        fun: 100,
        isHatched: true,
        isDeleted: false,
        petHistory: PetHistory(id: "681b90cdbd5d08c71c6c685a", petId: "681b90cdbd5d08c71c6c6859", actions: [], isDeleted: false, version: 0),
        version: 0,
        hatchedAt: "2025-05-07T16:56:58.777Z",
        nextBarUpdate: "2025-05-08T16:56:58.777Z",
        isHatchedByThisEgg: nil
    ), selectedTab: .constant(0), vm: InventoryViewModel())
}

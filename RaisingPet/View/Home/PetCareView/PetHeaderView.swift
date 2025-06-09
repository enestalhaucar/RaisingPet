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
    @Binding var showEditPopup: Bool
    private var petImageName: String {
        switch pet.petType.name.lowercased() {
        case "dog": return "dog"
        case "dalmatian": return "dalmacian"
        case "cat": return "cat"
        case "shiba": return "shiba"
        case "duck": return "duck"
        case "frog": return "frog"
        case "fox": return "fox"
        case "panda": return "panda"
        default: return "pawprint.fill"
        }
    }

    var body: some View {
        ZStack {
            Image("petCareViewBg")
                .resizable()
                .scaledToFill()
                .frame(height: ConstantManager.Layout.heightHalf)
                .clipped()
            VStack(spacing: 0) {
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Image("historyIcon")
                            Text("pet_header_view_history".localized())
                                .font(.nunito(.semiBold, .caption211))
                        }
                        Image("LuckyDraw").hidden()
                    }
                    Spacer()
                    AnimatedPetView(petTypeName: pet.petType.name)
                    Spacer()
                    VStack(spacing: 20) {
                        NavigationLink(destination: ShopScreenView()) {
                            VStack(spacing: 8) {
                                Image("furnitureIcon")
                                Text("pet_header_view_furniture".localized())
                                    .font(.nunito(.semiBold, .caption211))
                            }
                        }
                        VStack(spacing: 8) {
                            Image("dormIcon")
                            Text("pet_header_view_dorm".localized())
                                .font(.nunito(.semiBold, .caption211))
                        }
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
                PetTabBarView(selectedTab: $selectedTab, vm: vm)
                    .padding(.bottom, 10)
            }
        }
        .frame(height: ConstantManager.Layout.heightHalf)
        .ignoresSafeArea(.all)
        .onAppear {
            vm.currentPet = pet // Pet'i ayarla
        }
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
        petCalling: "myparent",
        petName: "Fluffy Duck",
        version: 0,
        hatchedAt: "2025-05-07T16:56:58.777Z",
        nextBarUpdate: "2025-05-08T16:56:58.777Z",
        isHatchedByThisEgg: nil
    ), selectedTab: .constant(0), vm: InventoryViewModel(), showEditPopup: .constant(false))
}

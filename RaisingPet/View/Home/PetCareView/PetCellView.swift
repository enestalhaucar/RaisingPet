//
//  PetCellView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

import SwiftUI

struct PetCellView: View {
    let pet: Pet

    // Hayvan adına göre systemImage seçimi
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
        NavigationLink(destination: PetCareView(pet: pet)) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 90)
                        .shadow(radius: 4)
                    Image(petImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                Text(pet.petName.capitalized)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
    }
}

//#Preview {
//    PetCellView(pet: Pet(
//        id: "681b90cdbd5d08c71c6c6859",
//        ownerId: "68191ca3bd5d08c71c6bfadd",
//        petName : "Enes",
//        petType: PetType(
//            id: "67fa53e58c1037768903c12a",
//            rarity: Rarity(
//                id: "67fa52d58c1037768903c118",
//                rarityName: "common",
//                weight: 50,
//                isDeleted: false,
//                version: 0
//            ),
//            name: "duck",
//            isDeleted: false,
//            version: 0
//        ),
//        hunger: 100,
//        thirst: 100,
//        hygiene: 100,
//        fun: 100,
//        isHatched: true,
//        isDeleted: false,
//        petHistory: PetHistory(
//            id: "681b90cdbd5d08c71c6c685a",
//            petId: "681b90cdbd5d08c71c6c6859",
//            actions: [
//                Action(
//                    id: "681b90cdbd5d08c71c6c685b",
//                    actionType: "create",
//                    performedBy: "68191ca3bd5d08c71c6bfadd",
//                    madeAt: "2025-05-07T16:56:45.962Z"
//                )
//            ],
//            isDeleted: false,
//            version: 0
//        ),
//        version: 0,
//        petCalling: "Selam",
//        hatchedAt: "2025-05-07T16:56:58.777Z",
//        nextBarUpdate: "2025-05-08T16:56:58.777Z",
//        isHatchedByThisEgg: nil
//    ))
//}

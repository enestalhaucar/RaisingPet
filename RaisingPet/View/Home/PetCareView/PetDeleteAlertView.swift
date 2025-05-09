//
//  PetDeleteAlertView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

import SwiftUI

struct PetDeleteAlertView: View {
    let pet: Pet
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: InventoryViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.blue, lineWidth: 1))

            VStack(spacing: 10) {
                Image("deletingBG")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.size.width * 0.7, height: UIScreen.main.bounds.size.width * 0.7)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)

                Text("\(pet.petType.name.capitalized)’yı ormana bıraktığında sonsuza kadar senden ayrı olucak ve vahşi doğada hayatta kalmaya çalışıcak")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                HStack {
                    Button {
                        isPresented = false
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.red.opacity(0.3))
                            Text("İptal")
                        }
                        .padding(.leading)
                        .frame(height: 40)
                    }
                    Spacer()
                    Button {
                        Task {
                            do {
                                try await vm.deletePet(petId: pet.id ?? "")
                                isPresented = false
                                dismiss() // PetCareView'ı kapatıp EggAndPetsView'a dön
                            } catch {
                                print("Pet silme hatası: \(error)")
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.blue.opacity(0.3))
                            Text("Pet'i sil")
                        }
                        .padding(.trailing)
                        .frame(height: 40)
                    }
                }
                .padding(.bottom, 15)
            }
        }
        .frame(width: UIScreen.main.bounds.size.width * 0.8)
        .frame(maxHeight: UIScreen.main.bounds.size.height * 0.55)
    }
}

#Preview {
    PetDeleteAlertView(pet: Pet(
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
    ), isPresented: .constant(true))
        .environmentObject(InventoryViewModel())
}

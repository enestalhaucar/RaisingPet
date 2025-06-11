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
        case "dalmatian": return "dalmatian"
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

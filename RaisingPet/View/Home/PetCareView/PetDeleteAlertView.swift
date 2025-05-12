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

                Text(String(format: "pet_delete_message".localized(), pet.petType.name.capitalized))
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
                            Text("friends_cancel_button".localized())
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
                            Text("pet_delete_button".localized())
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

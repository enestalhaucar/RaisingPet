//
//  PetNameEditPopupView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 3.06.2025.
//

import SwiftUI

struct PetNameEditPopupView: View {
    @Binding var isPresented: Bool
    @State private var petName: String
    @State private var petCalling: String
    
    let pet: Pet
    let onSave: (String, String) -> Void
    
    init(isPresented: Binding<Bool>, pet: Pet, onSave: @escaping (String, String) -> Void) {
        self._isPresented = isPresented
        self.pet = pet
        self.onSave = onSave
        self._petName = State(initialValue: pet.petName ?? pet.petType.name.capitalized)
        self._petCalling = State(initialValue: pet.petCalling ?? "pet_calling_default".localized())
    }
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 20) {
                // Title
                Text("pet_name_edit_title".localized())
                    .font(.nunito(.bold, .title320))
                    .foregroundColor(.black)
                
                VStack(spacing: 16) {
                    // Pet Name Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("pet_name_label".localized())
                            .font(.nunito(.semiBold, .callout14))
                            .foregroundColor(.gray)
                        
                        TextField("pet_name_placeholder".localized(), text: $petName)
                            .font(.nunito(.medium, .body16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(petName.count >= 12 ? Color.red : Color.clear, lineWidth: 1)
                            )
                            .onChange(of: petName) { newValue in
                                let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                                if filtered.count <= 12 {
                                    petName = filtered
                                } else {
                                    petName = String(filtered.prefix(12))
                                }
                            }
                        
                        if petName.count >= 12 {
                            Text("pet_name_limit_info".localized())
                                .font(.nunito(.regular, .caption12))
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Pet Calling Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("pet_calling_label".localized())
                            .font(.nunito(.semiBold, .callout14))
                            .foregroundColor(.gray)
                        
                        TextField("pet_calling_placeholder".localized(), text: $petCalling)
                            .font(.nunito(.medium, .body16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(petCalling.count >= 12 ? Color.red : Color.clear, lineWidth: 1)
                            )
                            .onChange(of: petCalling) { newValue in
                                let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                                if filtered.count <= 12 {
                                    petCalling = filtered
                                } else {
                                    petCalling = String(filtered.prefix(12))
                                }
                            }
                        
                        if petCalling.count >= 12 {
                            Text("pet_calling_limit_info".localized())
                                .font(.nunito(.regular, .caption12))
                                .foregroundColor(.red)
                        }
                    }
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    // Cancel Button
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("pet_name_edit_cancel".localized())
                            .font(.nunito(.semiBold, .body16))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    
                    // Save Button
                    Button(action: {
                        onSave(petName.trimmingCharacters(in: .whitespacesAndNewlines), 
                               petCalling.trimmingCharacters(in: .whitespacesAndNewlines))
                        isPresented = false
                    }) {
                        Text("pet_name_edit_save".localized())
                            .font(.nunito(.semiBold, .body16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    .disabled(petName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(petName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    PetNameEditPopupView(
        isPresented: .constant(true),
        pet: Pet(
            id: "test",
            ownerId: "test",
            petType: PetType(
                id: "test",
                rarity: Rarity(id: "test", rarityName: "common", weight: 50, isDeleted: false, version: 0),
                name: "cat",
                isDeleted: false,
                version: 0
            ),
            hunger: 100,
            thirst: 100,
            hygiene: 100,
            fun: 100,
            isHatched: true,
            isDeleted: false,
            petHistory: PetHistory(id: "test", petId: "test", actions: [], isDeleted: false, version: 0),
            petCalling: "myparent",
            petName: "Fluffy",
            version: 0,
            hatchedAt: "",
            nextBarUpdate: "",
            isHatchedByThisEgg: nil
        ),
        onSave: { name, calling in
            print("Saved: \(name), \(calling)")
        }
    )
} 

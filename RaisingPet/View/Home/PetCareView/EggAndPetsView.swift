//
//  PetView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 21.08.2024.
//

import SwiftUI

struct EggAndPetsView: View {
    @StateObject private var vm = InventoryViewModel()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    @State private var showEggsSection = true
    @State private var selectedEggData: InventoryItem?

    var body: some View {
        NavigationStack {
            ZStack {
                Image("petScreenBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.8)

                if vm.isLoading {
                    ProgressView()
                        .padding(.top, 50)
                } else if let error = vm.errorMessage {
                    VStack {
                        Text(String(format: "egg_pets_error".localized(), error))
                            .foregroundColor(.red)
                            .padding()
                        Button("egg_pets_retry".localized()) {
                            Task {
                                await vm.fetchInventory()
                                await vm.fetchPets()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    VStack(spacing: 0) {
                        // Fixed header buttons at the top
                        headerButtons
                            .padding(.top, 24)

                        // Yumurtalar Bölümü - Açılıp Kapanabilen (Fixed, not in ScrollView)
                        SectionHeaderView(
                            title: "egg_pets_eggs".localized(),
                            isCollapsible: true,
                            isExpanded: $showEggsSection
                        )
                        .padding(.top, 32)

                        if showEggsSection {
                            if vm.eggs.isEmpty {
                                EmptyEggStateView()
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: [GridItem(.flexible())], spacing: 16) {
                                        ForEach(Array(vm.eggs.enumerated()), id: \.offset) { _, egg in
                                            EggCellView(item: egg) {
                                                selectedEggData = egg
                                            }
                                            .padding(.horizontal, 4)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .padding(.horizontal, 8)
                                .frame(height: 160)
                            }
                        }

                        // Sahiplendiklerin Bölümü (Header is fixed)
                        SectionHeaderView(
                            title: "egg_pets_adopted".localized(),
                            isCollapsible: false
                        )
                        .padding(.top, 16)

                        // Only this part is scrollable
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(vm.pets) { pet in
                                    PetCellView(pet: pet)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                        .refreshable {
                            await vm.fetchInventory()
                            await vm.fetchPets()
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 16)
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .task {
                await vm.fetchInventory()
                await vm.fetchPets()
            }
            .alert(isPresented: .init(get: { vm.errorMessage != nil }, set: { _ in vm.errorMessage = nil })) {
                Alert(
                    title: Text("friends_error_title".localized()),
                    message: Text(vm.errorMessage ?? "friends_unknown_error".localized()),
                    dismissButton: .default(Text("friends_alert_ok".localized()))
                )
            }
            .fullScreenCover(item: $selectedEggData) { eggData in
                    HatchEggView(
                    item: eggData,
                        onClose: {
                            selectedEggData = nil
                        },
                        onHatch: { eggId in
                            Task {
                                do {
                                    _ = try await vm.hatchPets([eggId])
                                    await vm.fetchInventory()
                                    await vm.fetchPets()
                                    selectedEggData = nil
                                } catch {
                                    print("Hatch error: \(error)")
                                    vm.errorMessage = "Yumurta kırma başarısız: \(error.localizedDescription)"
                                }
                            }
                        }
                    )
            }
        }
    }

    private var headerButtons: some View {
        HStack(spacing: 8) {
            Button { /* Yeni yumurta al */ } label: {
                VStack(spacing: 8) {
                    Image("getNewEgg").resizable().frame(width: 32, height: 32)
                    Text("egg_pets_get_new_egg".localized()).font(.system(size: 12))
                }
            }
            Spacer()
            NavigationLink(destination: ShopScreenView()) {
                VStack(spacing: 8) {
                    Image("GoMarket")
                    Text("egg_pets_go_market".localized()).font(.system(size: 12))
                }
            }
            Spacer()
            Button { /* Ebeveynlik Yap */ } label: {
                VStack(spacing: 8) {
                    Image("parent")
                    Text("egg_pets_parenting".localized()).font(.system(size: 12))
                }
            }
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    EggAndPetsView()
}

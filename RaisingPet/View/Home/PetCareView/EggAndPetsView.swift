//
//  PetView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 21.08.2024.
//

import SwiftUI

struct EggAndPetsView: View {
    @StateObject private var vm = InventoryViewModel()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

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
                        Text("Hata: \(error)")
                            .foregroundColor(.red)
                            .padding()
                        Button("Yeniden Dene") {
                            Task {
                                await vm.fetchInventory()
                                await vm.fetchPets()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            headerButtons

                            // Yumurtalar Bölümü
                            SectionHeaderView(title: "Yumurtalar")
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(vm.eggs, id: \.id) { egg in
                                    EggCellView(item: egg) {
                                        guard let id = egg.id else { return }
                                        Task {
                                            do {
                                                _ = try await vm.hatchPets([id])
                                                await vm.fetchInventory()
                                                await vm.fetchPets() // Hatch sonrası petleri yenile
                                            } catch {
                                                print("Hatch error: \(error)")
                                                vm.errorMessage = "Yumurta kırma başarısız: \(error.localizedDescription)"
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)

                            // Sahiplendiklerin Bölümü
                            SectionHeaderView(title: "Sahiplendiklerin")
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(vm.pets) { pet in
                                    PetCellView(pet: pet)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.vertical, 16)
                    }
                    .refreshable {
                        await vm.fetchInventory()
                        await vm.fetchPets()
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .task {
                await vm.fetchInventory()
                await vm.fetchPets()
            }
            .alert(isPresented: .init(get: { vm.errorMessage != nil }, set: { _ in vm.errorMessage = nil })) {
                Alert(title: Text("Hata"), message: Text(vm.errorMessage ?? "Bilinmeyen hata"), dismissButton: .default(Text("Tamam")))
            }
        }
    }

    private var headerButtons: some View {
        HStack(spacing: 12) {
            Button { /* Yeni yumurta al */ } label: {
                VStack(spacing: 8) {
                    Image("getNewEgg").resizable().frame(width: 32, height: 32)
                    Text("Yeni Yumurta Al").font(.system(size: 12))
                }
            }
            Spacer()
            NavigationLink(destination: ShopScreenView()) {
                VStack(spacing: 8) {
                    Image("GoMarket")
                    Text("Markete Git").font(.system(size: 12))
                }
            }
            Spacer()
            Button { /* Ebeveynlik Yap */ } label: {
                VStack(spacing: 8) {
                    Image("parent")
                    Text("Ebeveynlik Yap").font(.system(size: 12))
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct SectionHeaderView: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "ellipsis")
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    EggAndPetsView()
}

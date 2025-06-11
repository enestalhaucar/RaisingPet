//
//  ShopScreenView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.08.2024.
//

import SwiftUI

// MARK: - MainCategory

enum MainCategory: String, CaseIterable {
    case diamonds = "shop_category_diamonds"
    case pets     = "shop_category_pets"
}

// MARK: - ShopScreenView

struct ShopScreenView: View {
    @StateObject private var vm = ShopScreenViewModel()
    @EnvironmentObject var currentUserVM: CurrentUserViewModel
    @State private var selectedMain: MainCategory = .pets // Varsayılan olarak Pets seçili
    @EnvironmentObject var interstitialManager: InterstitialAdsManager

    // — single ShopItem için
    @State private var selectedShopItem: ShopItem?
    @State private var counterNumber = 1
    @State private var showCounter = false

    // — PetItemPackage için
    @State private var showPackagePopup = false
    @State private var packageItems: [PetItemType] = []
    @State private var selectedPetItemPackage: PetItemPackage?
    @State private var packageLimit = 0
    
    // — Paket alımları için uyarılar
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var isShowingAd = false
    @State private var isAdPackage: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("shopBackgroundColor").ignoresSafeArea()

                if vm.isLoading {
                    ProgressView().padding(.top, 50)
                } else {
                    VStack(spacing: 0) {
                        RoofSideView()
                            .frame(maxWidth: .infinity)
                            .offset(y: -30)
                        CategoryPicker(selected: $selectedMain)

                        ScrollView {
                            if selectedMain == .diamonds {
                                DiamondSection(
                                    items: vm.allItems?.shopItems ?? [],
                                    onSelect: openSheet
                                )
                            } else {
//                                EggPackageSection(
//                                  eggs: vm.allItems?.eggPackages ?? [],
//                                  onSelect: openSheet
//                                )
//                                
                                PetItemPackageSection(
                                  packages: vm.allItems?.petItemPackages ?? [],
                                  onSelect: { pkg in
                                    handlePackageTap(pkg)
                                  }
                                )
                                EggSingleSection(
                                    items: vm.allItems?.shopItems ?? [],
                                    onSelect: openSheet
                                )
                                PetItemGroupsSection(
                                    petItems: vm.allItems?.petItems ?? [],
                                    onSelect: openSheet
                                )
//                                HomeSection(
//                                    items: vm.allItems?.shopItems ?? [],
//                                    onSelect: openSheet
//                                )
                            }
                        }
                        .padding(.top, 20)
                        .frame(width: ConstantManager.Layout.screenWidth)
                    }

                    // Pet-item-package pop-up
                    if showPackagePopup {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture { showPackagePopup = false }
                        BuyPackageCounterPopUpView(
                          petItems: packageItems,
                          limit: packageLimit,
                          isPresented: $showPackagePopup,
                          isAdPackage: isAdPackage
                        ) { selections in
                          guard let pkg = selectedPetItemPackage,
                                !selections.isEmpty else { return }

                          Task {
                              await vm.buyPackageItem(
                                packageType: .petItemPackage,
                                packageId: pkg.id ?? "",
                                petItemsWithAmounts: selections
                              ) {
                                  currentUserVM.refresh()
                              }
                          }
                        }
                        .frame(
                            width: UIScreen.main.bounds.width * 0.9,
                            height: 500
                        )
                        .zIndex(1)
                    }
                    
                    // Reklam yükleniyor göstergesi
                    if isShowingAd {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        ProgressView("Reklam Yükleniyor...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(20)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .zIndex(2)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                Task {
                    vm.fetchAllShopItem() {
                        currentUserVM.refresh()
                    }
                    interstitialManager.loadInterstitialAd()
                }
            }
            .ignoresSafeArea(edges: .top)
            .sheet(item: $selectedShopItem) { item in
                BottomSheetView(
                    item: item,
                    counterNumber: $counterNumber,
                    showCounter: $showCounter
                )
                .environmentObject(vm)
                .environmentObject(currentUserVM)
                .presentationDetents([.fraction(0.5)])
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
        }
    }

    private func openSheet(for item: ShopItem) {
        let isPetItem = vm.allItems?.petItems.contains(where: { $0.id == item.id }) ?? false
        showCounter = isPetItem
        counterNumber = 1
        selectedShopItem = item
    }
    
    // MARK: - Paket Tıklama Yönetimi
    private func handlePackageTap(_ pkg: PetItemPackage) {
        guard let user = currentUserVM.user, let packageId = pkg.id else { return }
        let name = pkg.name ?? ""

        if name.contains("Ad") {
            isAdPackage = true
            openPackagePopup(pkg)
            
        } else if name.contains("Premium") {
            isAdPackage = false
            guard user.role == "premium" else {
                alertTitle = "Premium'a Özel"
                alertMessage = "Bu paket sadece premium üyelere özeldir."
                showAlert = true
                return
            }
            
            // Bekleme süresi kontrolü zaten arayüzde yapılıyor, bu ek bir güvence.
            if let _ = packageState(for: pkg).remainingTime { return }
            
            openPackagePopup(pkg)
            
        } else { // "Free" paket olduğunu varsayıyoruz
            isAdPackage = false
            if let _ = packageState(for: pkg).remainingTime { return }

            openPackagePopup(pkg)
        }
    }
    
    private func openPackagePopup(_ pkg: PetItemPackage) {
        selectedPetItemPackage = pkg
        packageItems = pkg.petItemTypes ?? []
        packageLimit = pkg.limit ?? 0
        showPackagePopup = true
    }
    
    // Kullanıcı modelinde `packageClaimDates: [String: Date]?` olduğunu varsayar.
    private func packageState(for pkg: PetItemPackage) -> (remainingTime: TimeInterval?, isTappable: Bool) {
        guard let user = currentUserVM.user, let packageId = pkg.id else {
            return (nil, false)
        }
        
        let name = pkg.name ?? ""

        if name.contains("Premium") && user.role != "premium" {
            return (nil, false)
        }
        
        if name.contains("Free") || name.contains("Premium") {
            if let lastClaimDate = user.packageClaimDates?[packageId] {
                let cooldown: TimeInterval = 24 * 60 * 60
                let nextDate = lastClaimDate.addingTimeInterval(cooldown)
                if Date() < nextDate {
                    let remaining = nextDate.timeIntervalSince(Date())
                    return (remaining, false)
                }
            }
        }
        
        return (nil, true)
    }
}

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

    // — single ShopItem için
    @State private var selectedShopItem: ShopItem?
    @State private var counterNumber = 1
    @State private var showCounter = false

    // — PetItemPackage için
    @State private var showPackagePopup = false
    @State private var packageItems: [PetItemType] = []
    @State private var selectedPetItemPackage: PetItemPackage?
    @State private var packageLimit = 0

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
                                EggPackageSection(
                                  eggs: vm.allItems?.eggPackages ?? [],
                                  onSelect: openSheet
                                )
                                
                                PetItemPackageSection(
                                  packages: vm.allItems?.petItemPackages ?? [],
                                  onSelect: { pkg in
                                    selectedPetItemPackage = pkg
                                    packageItems = pkg.petItemTypes ?? []
                                    packageLimit = pkg.limit ?? 0
                                    showPackagePopup = true
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
                                HomeSection(
                                    items: vm.allItems?.shopItems ?? [],
                                    onSelect: openSheet
                                )
                            }
                        }
                        .padding(.top, 20)
                        .frame(width: Utilities.Constants.width)
                    }

                    // Pet-item-package pop-up
                    if showPackagePopup {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture { showPackagePopup = false }
                        BuyPackageCounterPopUpView(
                          petItems: packageItems,
                          limit: packageLimit,
                          isPresented: $showPackagePopup
                        ) { selections in
                          guard let pkg = selectedPetItemPackage,
                                !selections.isEmpty else { return }

                          vm.buyPackageItem(
                            packageType: .petItemPackage,
                            packageId: pkg.id ?? "",
                            petItemsWithAmounts: selections
                          )
                        }
                        .frame(
                            width: UIScreen.main.bounds.width * 0.9,
                            height: 500
                        )
                        .zIndex(1)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                vm.fetchAllShopItem() {
                    currentUserVM.refresh()
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
                .presentationDetents([.fraction(0.5)])
            }
        }
    }

    private func openSheet(for item: ShopItem) {
        let isPetItem = vm.allItems?.petItems.contains(where: { $0.id == item.id }) ?? false
        showCounter = isPetItem
        counterNumber = 1
        selectedShopItem = item
    }
}

// MARK: - CategoryPicker

struct CategoryPicker: View {
    @Binding var selected: MainCategory
    // Production’da Diamonds gizlensin (bu hardcoded, istersen bir environment değişkeni ile kontrol edebilirsin)
    private let visibleCategories: [MainCategory] = [.pets] // Şu an sadece Pets görünecek

    var body: some View {
        HStack(spacing: 16) {
            ForEach(visibleCategories, id: \.self) { cat in
                Text(cat.rawValue.localized())
                    .font(.nunito(.bold, .callout14))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selected == cat
                                  ? Color.accentColor.opacity(0.1)
                                  : .white)
                            .overlay(
                              RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1)
                            )
                    )
                    .opacity(selected == cat ? 1 : 0.5)
                    .onTapGesture { selected = cat }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Generic 3-Column Grid

struct ThreeColumnGrid<Item, ID: Hashable, Content: View>: View {
    let items: [Item]
    let id: KeyPath<Item,ID>
    @ViewBuilder let content: (Item) -> Content

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: .init(.flexible()), count: 3),
            spacing: 16
        ) {
            ForEach(items, id: id) { item in
                content(item)
            }
        }
        .padding(.horizontal)
        .frame(width: Utilities.Constants.width)
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title.localized())
            .font(.title3).bold()
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Sections

struct DiamondSection: View {
    let items: [ShopItem]
    let onSelect: (ShopItem) -> Void

    var body: some View {
        ThreeColumnGrid(items: items.filter { $0.category == .gameCurrencyDiamond },
                        id: \.id) { item in
            ShopItemView(
                imageName: item.name ?? "diamondPlaceholder",
                goldCost: item.goldPrice,
                diamondCost: item.diamondPrice,
                price: item.price.map { "$\($0)" }
            ) {
                onSelect(item)
            }
        }
    }
}

struct EggPackageSection: View {
    let eggs: [EggPackage]
    let onSelect: (ShopItem) -> Void

    var body: some View {
        SectionHeader(title: "shop_section_egg_packages")
        ThreeColumnGrid(items: eggs, id: \.id) { egg in
            ShopItemView(
                imageName: egg.name ?? "eggPlaceholder",
                goldCost: egg.goldPrice,
                diamondCost: egg.diamondPrice,
                price: nil
            ) {
                let shopItem = ShopItem(
                    id:         egg.id,
                    name:       egg.name,
                    description: egg.description,
                    category:   .eggs,
                    isDeleted:  egg.isDeleted,
                    v:          egg.v,
                    duration:   egg.eggType?.duration,
                    isPurchasable: true,
                    diamondPrice: egg.diamondPrice,
                    goldPrice:    egg.goldPrice,
                    quantity:     egg.amount,
                    price:        nil,
                    isOwned:      false
                )
                onSelect(shopItem)
            }
        }
    }
}

struct PetItemPackageSection: View {
    let packages: [PetItemPackage]
    let onSelect: (PetItemPackage) -> Void

    var body: some View {
        SectionHeader(title: "shop_section_pet_item_packages")

        ThreeColumnGrid(items: packages, id: \.id) { pkg in
            ShopItemView(
                imageName: pkg.name ?? "petPackagePlaceholder",
                goldCost: nil,
                diamondCost: nil,
                price: String(format: "shop_limit".localized(), pkg.limit ?? 0)
            ) {
                onSelect(pkg)
            }
        }
    }
}

struct EggSingleSection: View {
    let items: [ShopItem]
    let onSelect: (ShopItem) -> Void

    var body: some View {
        SectionHeader(title: "shop_section_single_eggs")
        ThreeColumnGrid(items: items.filter { $0.category == .eggs },
                        id: \.id) { item in
            ShopItemView(
                imageName: item.name ?? "eggPlaceholder",
                goldCost: item.goldPrice,
                diamondCost: item.diamondPrice,
                price: nil
            ) {
                onSelect(item)
            }
        }
    }
}

struct PetItemGroupsSection: View {
    let petItems: [PetItem]
    let onSelect: (ShopItem) -> Void

    private let allGroups: [(title: String, key: String)] = [
        ("shop_group_edible".localized(),    "edibleMaterial"),
        ("shop_group_drinkable".localized(), "drinkableMaterial"),
        ("shop_group_cleaning".localized(),  "cleaningMaterial"),
        ("shop_group_fun".localized(),       "funMaterial")
    ]

    private var nonEmptyGroups: [(title: String, key: String)] {
        allGroups.filter { group in
            petItems.contains { $0.effectType == group.key }
        }
    }

    var body: some View {
        ForEach(nonEmptyGroups, id: \.key) { section in
            let filtered = petItems.filter { $0.effectType == section.key }

            SectionHeader(title: section.title)

            ThreeColumnGrid(items: filtered, id: \.id) { pet in
                ShopItemView(
                    imageName: pet.name ?? "foodIcon",
                    goldCost:   pet.goldPrice,
                    diamondCost: pet.diamondPrice,
                    price:      nil
                ) {
                    onSelect(pet.toShopItem())
                }
            }
        }
    }
}

struct HomeSection: View {
    let items: [ShopItem]
    let onSelect: (ShopItem) -> Void

    var body: some View {
        SectionHeader(title: "shop_section_home_items")
        ThreeColumnGrid(items: items.filter { $0.category == .home },
                        id: \.id) { item in
            ShopItemView(
                imageName: item.name ?? "homeIcon",
                goldCost: item.goldPrice,
                diamondCost: item.diamondPrice,
                price: nil
            ) {
                onSelect(item)
            }
        }
    }
}

// MARK: - RoofSideView

struct RoofSideView: View {
    @EnvironmentObject var currentUser: CurrentUserViewModel
    var body: some View {
        ZStack {
            Image("shopRoof")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .ignoresSafeArea(edges: .top)
                .clipped()
            
            HStack(spacing: 16) {
                BackButtonView()
                    .padding(.leading, 16)
                
                AssetNumberView(iconName: "goldIcon", currencyType: .gold)
                AssetNumberView(iconName: "diamondIcon", currencyType: .diamond)
                Spacer()
                RestoreButtonView()
                    .padding(.trailing, 16)
            }.frame(width: Utilities.Constants.width)
            .padding(.top, 50)
        }
    }
}

// MARK: - ShopItemView

struct ShopItemView: View {
    let imageName: String
    let goldCost: Int?
    let diamondCost: Int?
    let price: String?
    var onTap: () -> Void
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.05))
                .frame(width: 120, height: 120)
            
            VStack(spacing: 0) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 120, height: 1)
                
                if let priceText = price {
                    Text(priceText)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .padding(5)
                        .frame(width: 120, height: 39)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.yellow.opacity(0.2))
                        )
                } else {
                    HStack(spacing: 5) {
                        if let gold = goldCost, diamondCost == nil {
                            Image("goldIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("\(gold)")
                                .font(.nunito(.bold, .callout14))
                                .foregroundColor(.black)
                        }
                        else if let diamond = diamondCost, goldCost == nil {
                            Image("diamondIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("\(diamond)")
                                .font(.nunito(.bold, .callout14))
                                .foregroundColor(.black)
                        }
                        else if let gold = goldCost, let diamond = diamondCost {
                            Image("goldIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("\(gold)")
                                .font(.nunito(.bold, .callout14))
                                .foregroundColor(.black)
                            
                            Text("/")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                            
                            Image("diamondIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("\(diamond)")
                                .font(.nunito(.bold, .callout14))
                                .foregroundColor(.black)
                        } else {
                            EmptyView()
                        }
                    }
                    .minimumScaleFactor(0.6)
                    .padding(5)
                    .frame(width: 120, height: 39)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.yellow.opacity(0.2))
                        )
                }
            }
        }.onTapGesture {
            onTap()
        }
    }
}

enum CurrencyGoldDiamondType {
    case gold
    case diamond
}
// MARK: - AssetNumberView

struct AssetNumberView: View {
    @EnvironmentObject var currentUserVM: CurrentUserViewModel
    let iconName: String
    let currencyType: CurrencyGoldDiamondType
    
    private var number: Int {
        switch currencyType {
        case .gold:
            return currentUserVM.user?.gameCurrencyGold ?? 0
        case .diamond:
            return currentUserVM.user?.gameCurrencyDiamond ?? 0
        }
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 5) {
                Image(iconName)
                    .resizable()
                    .frame(width: 15, height: 15)
                
                Text("\(number)")
                    .font(.nunito(.extraBold, .caption211))
                    .foregroundStyle(.accent)
                    .minimumScaleFactor(0.6)
                
                Image("plusIcon")
                    .resizable()
                    .frame(width: 10, height: 10)
            }
            .padding(.horizontal, 5)
            .frame(height: 24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .fill(.accent)
            )
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color("GoldBackgroundColor"))
            )
        }
        .onAppear {
            currentUserVM.refresh() // Her görünümde güncelle
        }
    }
}

// MARK: - BackButtonView

struct BackButtonView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Image("arrow_back")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .fill(.accent)
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                )
        }.onTapGesture {
            dismiss()
        }
    }
}

// MARK: - RestoreButtonView

struct RestoreButtonView: View {
    var body: some View {
        ZStack {
            Text("shop_restore_button".localized())
                .font(.nunito(.medium, .caption12))
                .frame(height: 20)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .fill(.accent)
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                )
        }
    }
}

// MARK: - Extensions

extension PetItemPackage {
    func toShopItem() -> ShopItem {
        ShopItem(
            id: id,
            name: name,
            description: description,
            category: .home,
            isDeleted: isDeleted,
            v: v,
            duration: nil,
            isPurchasable: true,
            diamondPrice: nil,
            goldPrice: nil,
            quantity: limit,
            price: nil,
            isOwned: false
        )
    }
}

extension PetItem {
    func toShopItem() -> ShopItem {
        ShopItem(
            id: id,
            name: name,
            description: description,
            category: .home,
            isDeleted: isDeleted,
            v: v,
            duration: nil,
            isPurchasable: true,
            diamondPrice: diamondPrice,
            goldPrice: goldPrice,
            quantity: nil,
            price: nil,
            isOwned: false
        )
    }
}

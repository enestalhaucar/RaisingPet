//
//  ShopScreenView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.08.2024.
//

import SwiftUI

enum MainCategory : String, CaseIterable {
    case diamonds = "Diamonds"
    case pets = "Pets"
}
struct ShopScreenView: View {
    @StateObject private var vm = ShopScreenViewModel()
    @State private var selectedMain: MainCategory = .diamonds
    
    @State private var selectedShopItem: ShopItem?
    @State private var counterNumber = 1
    @State private var showCounter = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("shopBackgroundColor")
                    .ignoresSafeArea()
                
                if vm.isLoading {
                    ProgressView().padding(.top, 50)
                } else {
                    VStack(spacing : 0) {
                        RoofSideView()
                            .frame(maxWidth: .infinity)
                            .offset(y: -30)
                        
                        CategoryPicker(selected: $selectedMain)
                        
                        Group {
                            switch selectedMain {
                            case .diamonds:
                                DiamondGrid(items: vm.allItems?.shopItems ?? [], onSelect: openSheet)
                            case .pets:
                                PetSections(allItems: vm.allItems, onSelect: openSheet)
                            }
                        }.padding(.top,25)
                        
                        Spacer()
                    }
                }
            }.onAppear {vm.fetchAllShopItem()}
                .ignoresSafeArea(edges: .top)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .sheet(item: $selectedShopItem) { item in
                BottomSheetView(item: item, counterNumber: $counterNumber, showCounter: $showCounter)
                    .environmentObject(vm)
                    .presentationDetents([.fraction(0.5)])
            }
        }
    }
    private func openSheet(for item: ShopItem) {
        counterNumber = 1
        // showCounter, item'in petItems olup olmamasına bağlı olarak ayarlanıyor
        showCounter = item.category == .home && vm.allItems?.petItems.contains(where: { $0.id == item.id }) ?? false
        selectedShopItem = item
    }
}

#Preview {
    ShopScreenView()
}

struct CategoryPicker: View {
    @Binding var selected: MainCategory
    var body: some View {
        HStack(spacing: 16) {
            ForEach(MainCategory.allCases, id: \.self) { cat in
                Text(cat.rawValue)
                    .font(.nunito(.bold, .callout14))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selected == cat ? Color.accentColor.opacity(0.1) : .white)
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

struct DiamondGrid: View {
    let items: [ShopItem]
    let onSelect: (ShopItem) -> Void
    let columns = [ GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()) ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(items.filter { $0.category == .gameCurrencyDiamond }) { item in
                ShopItemView(
                    imageName: item.name ?? "diamondPlaceholder",
                    goldCost: item.goldPrice,
                    diamondCost: item.diamondPrice,
                    price: item.price.map { "$\($0)" }
                ) {
                    onSelect(item)
                }
            }
        }.padding(.horizontal)
        .frame(width: Utilities.Constants.width)
    }
}

struct PetSections: View {
    let allItems: AllItems?
    let onSelect: (ShopItem) -> Void

    // petItems’i effectType’a göre grupluyoruz
    private let petGroups: [(title: String, key: String)] = [
        ("Edible Material",    "edibleMaterial"),
        ("Drinkable Material", "drinkableMaterial"),
        ("Cleaning Material",  "cleaningMaterial"),
        ("Fun Material",       "funMaterial")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .center ,spacing: 32) {
                // 1) Pet Item Packages
                if let pkgs = allItems?.petItemPackages, !pkgs.isEmpty {
                    SectionGrid(
                        title: "Pet Item Packages",
                        items: pkgs.map { pkg in
                            DisplayItem(
                                id: pkg.id ?? UUID().uuidString,
                                imageName: pkg.name ?? "Egg",
                                goldCost: nil,
                                diamondCost: nil,
                                priceText: nil,
                                model: pkg.toShopItem()
                            )
                        },
                        onSelect: onSelect
                    )
                }

                // 2) Egg Packages
                if let eggs = allItems?.eggPackages, !eggs.isEmpty {
                    SectionGrid(
                        title: "Egg Packages",
                        items: eggs.map { egg in
                            DisplayItem(
                                id: egg.id ?? UUID().uuidString,
                                imageName: egg.name ?? "Enchanted Egg",
                                goldCost: egg.goldPrice,
                                diamondCost: egg.diamondPrice,
                                priceText: nil,
                                model: ShopItem(
                                    id: egg.id,
                                    name: egg.name,
                                    description: egg.description,
                                    category: .eggs,
                                    isDeleted: egg.isDeleted,
                                    v: egg.v,
                                    duration: egg.eggType?.duration,
                                    isPurchasable: egg.isPurchasable,
                                    diamondPrice: egg.diamondPrice,
                                    goldPrice: egg.goldPrice,
                                    quantity: egg.amount,
                                    price: nil,
                                    isOwned: false
                                )
                            )
                        },
                        onSelect: onSelect
                    )
                }

                // 3) petItems gruplu bölümler
                if let pets = allItems?.petItems {
                    ForEach(petGroups, id: \.key) { group in
                        let filtered = pets.filter { $0.effectType == group.key }
                        if !filtered.isEmpty {
                            SectionGrid(
                                title: group.title,
                                items: filtered.map { pet in
                                    DisplayItem(
                                        id: pet.id ?? UUID().uuidString,
                                        imageName: pet.name ?? "foodIcon",
                                        goldCost: pet.goldPrice,
                                        diamondCost: pet.diamondPrice,
                                        priceText: nil,
                                        model: pet.toShopItem()
                                    )
                                },
                                onSelect: onSelect
                            )
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Model conversion helpers
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


struct SectionGrid: View {
    let title: String
    let items: [DisplayItem]
    let onSelect: (ShopItem) -> Void

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.nunito(.semiBold, .callout14))
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { display in
                    ShopItemView(
                        imageName: display.imageName,
                        goldCost: display.goldCost,
                        diamondCost: display.diamondCost,
                        price: display.priceText
                    ) {
                        onSelect(display.model)
                    }
                }
            }
            .padding(.horizontal)
            .frame(width: Utilities.Constants.width)
        }
    }
}


// 7) Grid’te kullanmak için basit model
struct DisplayItem: Identifiable {
    let id: String
    let imageName: String
    let goldCost: Int?
    let diamondCost: Int?
    let priceText: String?
    let model: ShopItem
}


struct AssetNumberView: View {
    var iconName: String
    var number: Int
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
            .frame(width: 60, height: 24)
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
    }
}

struct RoofSideView: View {
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
                AssetNumberView(iconName: "goldIcon", number: 5)
                AssetNumberView(iconName: "diamondIcon", number: 5)
                Spacer()
                RestoreButtonView()
                    .padding(.trailing, 16)
                
            }.frame(width: Utilities.Constants.width)
            .padding(.top, 50)
        }
    }
}

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

struct RestoreButtonView: View {
    var body: some View {
        ZStack {
            Text("restore".localized())
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

struct ShopCategoryView: View {
    @Binding var selectedCategory: ShopItemCategory
    var body: some View {
        ZStack {
            HStack(spacing: 16) {
                ShopCategoryComponentView(isSelected: selectedCategory == .eggs, imageName: "pawIcon", text: "Pets".localized()).onTapGesture { selectedCategory = .eggs}
                ShopCategoryComponentView(isSelected: selectedCategory == .gameCurrencyDiamond, imageName: "goldIcon", text: "gold".localized()).onTapGesture { selectedCategory = .gameCurrencyDiamond}
                ShopCategoryComponentView(isSelected: selectedCategory == .home, imageName: "homeCategoryIcon", text: "home".localized()).onTapGesture { selectedCategory = .home}
            }
        }
    }
}

struct ShopCategoryComponentView: View {
    var isSelected: Bool
    var imageName: String
    var text: String
    var body: some View {
        HStack(spacing: 3) {
            Image(imageName)
                .resizable()
                .frame(width: 20, height: 20)
            Text(text).font(.nunito(.bold, .callout14))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? .blue.opacity(0.1) : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 1)
                )
        )
        .opacity(isSelected ? 1 : 0.5)
    }
}

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

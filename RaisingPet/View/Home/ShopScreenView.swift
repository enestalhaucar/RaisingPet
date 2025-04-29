//
//  ShopScreenView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.08.2024.
//

import SwiftUI

struct ShopScreenView: View {
    @StateObject private var viewModel = ShopScreenViewModel()
    @State private var selectedCategory: ShopItemCategory = .eggs
    var body: some View {
        NavigationStack {
            ZStack {
                Color("shopBackgroundColor")
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    VStack(spacing: 0) {
                        RoofSideView()
                            .frame(maxWidth: .infinity)
                            .offset(y: -30)
                        
                        ShopCategoryView(selectedCategory: $selectedCategory)
                        
                        if let shopItems = viewModel.allItems?.shopItems {
                            ShopItemsView(shopItems: shopItems, selectedCategory: selectedCategory).padding(.top, 25)
                        } else {
                            ProgressView()
                                .padding(.top, 30)
                        }
                        
                        Spacer()
                    }
                }
            }.onAppear {
                viewModel.fetchAllShopItem()
                print("Fetch")
            }
            .ignoresSafeArea(edges: .top)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ShopScreenView()
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

struct ShopItemsView: View {
    let shopItems: [ShopItem]
    let selectedCategory: ShopItemCategory
    @State private var selectedItem: ShopItem?
    @State private var counterNumber: Int = 1
    @State private var showCounter: Bool = false

    var filteredItems: [ShopItem] {
        shopItems.filter { $0.category == selectedCategory }
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filteredItems, id: \.id) { item in
                    let imageName: String = {
                        if let name = item.name, !name.isEmpty {
                            return name
                        } else {
                            switch selectedCategory {
                            case .eggs:
                                return "eggPlaceholder"
                            case .gameCurrencyDiamond:
                                return "diamondPlaceholder"
                            case .home:
                                return "homePlaceholder"
                            }
                        }
                    }()

                    let displayPrice: String? = {
                        if selectedCategory == .gameCurrencyDiamond, let price = item.price {
                            return "$\(price)"
                        }
                        return nil
                    }()

                    ShopItemView(imageName: imageName,
                                 goldCost: item.goldPrice,
                                 diamondCost: item.diamondPrice,
                                 price: displayPrice) {
                        selectedItem = item
                    }
                }
            }
            .padding(.horizontal)
        }
        .sheet(item: $selectedItem) { item in
            BottomSheetView(item: item, counterNumber: $counterNumber, showCounter: $showCounter)
                .transition(.move(edge: .bottom))
                .zIndex(1)
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.hidden)
        }
        .frame(width: Utilities.Constants.width)
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
                    .scaledToFit()
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

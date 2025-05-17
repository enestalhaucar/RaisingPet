//
//  BuyButtomSheetView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.04.2025.
//

import SwiftUI

struct BottomSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var vm: ShopScreenViewModel
    @EnvironmentObject private var currentVM: CurrentUserViewModel
    var item: ShopItem
    @Binding var counterNumber: Int
    @State private var selectedMine: MineEnum? = nil
    @Binding var showCounter: Bool
    @State private var bottomSheetHeight: CGFloat = 0
    
    var body: some View {
        if item.category == .gameCurrencyDiamond {
            ZStack {
                VStack(spacing:20) {
                    HStack {
                        AssetNumberView(iconName: "goldIcon", currencyType: .gold)
                        AssetNumberView(iconName: "diamondIcon", currencyType: .diamond)
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        ItemImageView(imageName: item.name ?? "egg")
                        DescriptionOfItemView(item: item)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 15).fill(.yellow.opacity(0.05)))
                    .padding(.horizontal, 20)
                    
                    
                    Button {
                        Task {
                            await vm.buyShopItem(itemId: item.id!, mine: .diamond) {
                                currentVM.refresh()
                            }
                            dismiss()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .foregroundStyle(.yellow.opacity(0.3))
                            Text(String(format: "bottom_sheet_buy_diamonds".localized(), item.name?.capitalized ?? "", counterNumber))
                                .font(.nunito(.medium, .callout14))
                        }.padding(.horizontal, 20)
                    }
                }.background(Color.white)
                    .cornerRadius(25)
                    .padding(.top, 10)
            }
        } else {
            ZStack {
                VStack(spacing: 20) {
                    HStack {
                        AssetNumberView(iconName: "goldIcon", currencyType: .gold)
                        AssetNumberView(iconName: "diamondIcon", currencyType: .diamond)
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        ItemImageView(imageName: item.name ?? "egg")
                        if showCounter {
                            Spacer()
                            BuyCounterView(counterNumber: $counterNumber).minimumScaleFactor(0.8)
                        } else {
                            DescriptionOfItemView(item: item)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 15).fill(.yellow.opacity(0.05)))
                    .padding(.horizontal, 20)
                    
                    Text(String(format: "bottom_sheet_item_purchase".localized(), item.goldPrice ?? 0, item.goldPrice ?? 0))
                        .font(.nunito(.medium, .callout14))
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 10) {
                        if let diamondPrice = item.diamondPrice, diamondPrice > 0, item.goldPrice == nil || item.goldPrice == 0 {
                            // Sadece Diamond Butonu
                            BuyPurchaseView(
                                iconName: "diamondIcon",
                                itemName: item.name ?? "-",
                                counterNumber: counterNumber
                            ) {
                                selectedMine = .diamond
                                purchaseItem()
                            }
                        } else if let goldPrice = item.goldPrice, goldPrice > 0, item.diamondPrice == nil || item.diamondPrice == 0 {
                            // Sadece Gold Butonu
                            BuyPurchaseView(
                                iconName: "goldIcon",
                                itemName: item.name ?? "-",
                                counterNumber: counterNumber
                            ) {
                                selectedMine = .gold
                                purchaseItem()
                            }
                        } else if let diamondPrice = item.diamondPrice, let goldPrice = item.goldPrice, diamondPrice > 0, goldPrice > 0 {
                            // Hem Diamond hem Gold Butonları
                            BuyPurchaseView(
                                iconName: "diamondIcon",
                                itemName: item.name ?? "-",
                                counterNumber: counterNumber
                            ) {
                                selectedMine = .diamond
                                purchaseItem()
                            }
                            
                            Divider()
                            
                            BuyPurchaseView(
                                iconName: "goldIcon",
                                itemName: item.name ?? "-",
                                counterNumber: counterNumber
                            ) {
                                selectedMine = .gold
                                purchaseItem()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top)
                }
                .background(Color.white)
                .cornerRadius(25)
                .padding(.top, 10)
            }
        }
    }
    
    private func purchaseItem() {
      guard let id = item.id, let mine = selectedMine else { return }

      // 1) Eğer bu bir EggPackage ise:
      if let qty = item.quantity, item.category == .eggs {
        Task {
            await vm.buyPackageItem(
              packageType: .eggPackage,
              packageId: id,
              mine: mine
            ) { currentVM.refresh() }
            dismiss()
        }
        return
      }

      // 2) Eğer petItem ise (home+petItems)
      if item.category == .home && (vm.allItems?.petItems.contains { $0.id == id } ?? false) {
          Task {
              await vm.buyPetItem(itemId: id, amount: counterNumber, mine: mine) {
                  currentVM.refresh()
              }
              dismiss()
          }
        return
      }

      // 3) Aksi hâlde basit shopItem
        Task {
            await vm.buyShopItem(itemId: id, mine: mine) {
                currentVM.refresh()
            }
            dismiss()
        }
    }
}

struct ItemImageView: View {
    var imageName: String
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .frame(width: 100, height: 100)
        }
    }
}

struct BuyCounterView: View {
    @Binding var counterNumber: Int
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        if counterNumber > 1 {
                            counterNumber -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .opacity(counterNumber == 1 ? 0.3 : 1)
                    }
                    
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 90, height: 25)
                            .foregroundColor(.yellow.opacity(0.4))
                        
                        Text("\(counterNumber)")
                            .font(.nunito(.medium, .callout14))
                    }
                    Spacer()
                    Button {
                        if counterNumber < 10 {
                            counterNumber += 1
                        }
                    } label: {
                        Image(systemName: "plus")
                            .opacity(counterNumber == 10 ? 0.3 : 1)
                    }
                }.padding(.horizontal)
                HStack {
                    CounterItemBackgroundView(counterNumber: 3) { counterNumber = 3}
                    Spacer()
                    CounterItemBackgroundView(counterNumber: 5) { counterNumber = 5 }
                    Spacer()
                    CounterItemBackgroundView(counterNumber: 10, badgeVisible: true, onTap: { counterNumber = 10})
                }
            }.frame(width: Utilities.Constants.widthHalf)
        }
    }
}

struct CounterItemBackgroundView: View {
    var counterNumber: Int
    var badgeVisible: Bool = false
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 60, height: 25)
                .foregroundColor(.yellow.opacity(0.4))
            Text("\(counterNumber)")
                .font(.nunito(.medium, .callout14))
            
            if badgeVisible {
                HStack {
                    Spacer()
                    Text("bottom_sheet_badge_plus_one".localized())
                        .font(.nunito(.thin, .caption211))
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Circle().fill(Color.red))
                        .frame(width: 20, height: 20)
                        .offset(x: 10, y: -10)
                }
                .padding(5)
            }
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct DescriptionOfItemView: View {
    var item: ShopItem
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(item.name ?? " - ")")
                .font(.nunito(.semiBold, .body16))
            Text("\(item.description ?? " - ")")
                .font(.nunito(.medium, .callout14))
                .foregroundStyle(.gray.opacity(0.3))
        }
    }
}

struct BuyPurchaseView: View {
    var iconName: String
    var itemName: String
    var counterNumber: Int
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.yellow.opacity(0.3))
                HStack {
                    Image(iconName)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(String(format: "bottom_sheet_get_item".localized(), itemName.capitalized, counterNumber))
                        .font(.nunito(.medium, .callout14))
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

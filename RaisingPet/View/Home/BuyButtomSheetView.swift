//
//  BuyButtomSheetView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.04.2025.
//

import SwiftUI

struct BottomSheetView: View {
    @Environment(\.dismiss) private var dismiss
    var item: ShopItem
    @Binding var counterNumber: Int
    @State private var selectedMine: MineEnum? = nil
    @State private var viewModel = ShopScreenViewModel()
    @Binding var showCounter: Bool
    @State private var bottomSheetHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 20) {
                    HStack {
                        AssetNumberView(iconName: "diamondIcon", number: 50)
                        AssetNumberView(iconName: "goldIcon", number: 50)
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
                    
                    Text("Item purchase requires \(item.goldPrice ?? 0) you are \(item.goldPrice ?? 0) short")
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
            }.onAppear {
                bottomSheetHeight = geometry.size.height
            }
        }
    }
    
    private func purchaseItem() {
        guard let selectedMine = selectedMine,
              let id = item.id else {
            return
        }
        viewModel.buyItem(itemId: id, mine: selectedMine)
    }
}

#Preview {
    BottomSheetView(
        item: .init(id: "", name: "", description: "", category: .eggs, isDeleted: false, v: 0, duration: 0, isPurchasable: false, diamondPrice: 0, goldPrice: 0, quantity: 0, price: 0, isOwned: false),
        counterNumber: .constant(1),
        showCounter: .constant(true)
    )
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
                    Text("+1")
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
            Text(" 1 \(item.name ?? " - ")")
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
                    Text("Get \(itemName) x\(counterNumber)")
                        .font(.nunito(.medium, .callout14))
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

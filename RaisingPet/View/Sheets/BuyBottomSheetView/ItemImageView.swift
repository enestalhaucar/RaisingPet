//
//  ItemImageView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 13.06.2025.
//

import SwiftUI


// MARK: - Supporting Views
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
            }.frame(width: ConstantManager.Layout.widthHalf)
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

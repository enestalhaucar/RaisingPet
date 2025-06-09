//
//  ShopItemView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//

import SwiftUI

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
                    .frame(width: 65, height: 65)
                    .frame(alignment: .top)
                
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

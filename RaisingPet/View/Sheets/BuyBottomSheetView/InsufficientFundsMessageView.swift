//
//  InsufficientFundsMessageView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 13.06.2025.
//

import SwiftUI

// MARK: - Insufficient Funds Message
struct InsufficientFundsMessageView: View {
    let item: ShopItem
    let counterNumber: Int
    let showCounter: Bool
    let userGold: Int
    let userDiamond: Int
    @ObservedObject var vm: ShopScreenViewModel
    @ObservedObject var currentVM: CurrentUserViewModel

    private func getInsufficientFundsMessage() -> String? {
        let totalGoldPrice = (item.goldPrice ?? 0) * (showCounter ? counterNumber : 1)
        let totalDiamondPrice = (item.diamondPrice ?? 0) * (showCounter ? counterNumber : 1)

        // Sadece Gold fiyatı varsa
        if totalGoldPrice > 0 && totalDiamondPrice == 0 {
            if userGold < totalGoldPrice {
                let shortage = totalGoldPrice - userGold
                return String(format: "bottom_sheet_item_purchase".localized(), totalGoldPrice, shortage)
            }
        }
        // Sadece Diamond fiyatı varsa
        else if totalDiamondPrice > 0 && totalGoldPrice == 0 {
            if userDiamond < totalDiamondPrice {
                let shortage = totalDiamondPrice - userDiamond
                return String(format: "bottom_sheet_item_purchase".localized(), totalDiamondPrice, shortage)
            }
        }
        // Hem Gold hem Diamond varsa - herhangi biri ile alınabilir
        else if totalGoldPrice > 0 && totalDiamondPrice > 0 {
            let canAffordWithGold = userGold >= totalGoldPrice
            let canAffordWithDiamond = userDiamond >= totalDiamondPrice

            if !canAffordWithGold && !canAffordWithDiamond {
                // Her ikisi de yeterli değil - daha az eksik olanı göster
                let goldShortage = totalGoldPrice - userGold
                let diamondShortage = totalDiamondPrice - userDiamond

                if goldShortage <= diamondShortage {
                    return String(format: "bottom_sheet_item_purchase".localized(), totalGoldPrice, goldShortage)
                } else {
                    return String(format: "bottom_sheet_item_purchase".localized(), totalDiamondPrice, diamondShortage)
                }
            }
        }

        return nil
    }

    var body: some View {
        if let insufficientMessage = getInsufficientFundsMessage() {
            VStack(spacing: 15) {
                Text(insufficientMessage)
                    .font(.nunito(.medium, .callout14))
                    .foregroundStyle(.red)
                    .padding(.horizontal, 20)

                DiamondPurchaseOptionsView(vm: vm, currentVM: currentVM)
            }
        }
    }
}

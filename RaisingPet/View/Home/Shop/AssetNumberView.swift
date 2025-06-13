//
//  AssetNumberView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//
import SwiftUI

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
    }
}

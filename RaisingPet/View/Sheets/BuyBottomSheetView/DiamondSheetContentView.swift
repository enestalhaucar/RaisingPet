//
//  DiamondSheetContentView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 13.06.2025.
//

import SwiftUI

// MARK: - Diamond Sheet Content
struct DiamondSheetContentView: View {
    let item: ShopItem
    let counterNumber: Int
    let dismiss: DismissAction
    @ObservedObject var vm: ShopScreenViewModel
    @ObservedObject var currentVM: CurrentUserViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                SheetHeaderView(dismiss: dismiss)

                ItemInfoView(item: item, showCounter: .constant(false), counterNumber: .constant(counterNumber))

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
            }
            .background(Color.white)
            .cornerRadius(25)
            .padding(.top, 10)
        }
    }
}

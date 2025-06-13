//
//  RegularSheetContentView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 13.06.2025.
//

import SwiftUI

// MARK: - Regular Sheet Content
struct RegularSheetContentView: View {
    let item: ShopItem
    @Binding var counterNumber: Int
    @Binding var showCounter: Bool
    @Binding var selectedMine: MineEnum?
    let dismiss: DismissAction
    @ObservedObject var vm: ShopScreenViewModel
    @ObservedObject var currentVM: CurrentUserViewModel

    // Computed properties for user balances
    private var userGold: Int {
        currentVM.user?.gameCurrencyGold ?? 0
    }

    private var userDiamond: Int {
        currentVM.user?.gameCurrencyDiamond ?? 0
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                SheetHeaderView(dismiss: dismiss)

                ItemInfoView(item: item, showCounter: $showCounter, counterNumber: $counterNumber)

                InsufficientFundsMessageView(
                    item: item,
                    counterNumber: counterNumber,
                    showCounter: showCounter,
                    userGold: userGold,
                    userDiamond: userDiamond,
                    vm: vm,
                    currentVM: currentVM
                )

                PurchaseButtonsView(
                    item: item,
                    counterNumber: counterNumber,
                    selectedMine: $selectedMine,
                    userGold: userGold,
                    userDiamond: userDiamond,
                    showCounter: showCounter,
                    vm: vm,
                    currentVM: currentVM,
                    dismiss: dismiss
                )
            }
            .background(Color.white)
            .cornerRadius(25)
            .padding(.top, 10)
        }
    }
}

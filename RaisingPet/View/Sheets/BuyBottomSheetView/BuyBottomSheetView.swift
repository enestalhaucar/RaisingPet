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
    @State private var selectedMine: MineEnum?
    @Binding var showCounter: Bool
    @State private var bottomSheetHeight: CGFloat = 0

    var body: some View {
        if item.category == .gameCurrencyDiamond {
            DiamondSheetContentView(
                item: item,
                counterNumber: counterNumber,
                dismiss: dismiss,
                vm: vm,
                currentVM: currentVM
            )
        } else {
            RegularSheetContentView(
                item: item,
                counterNumber: $counterNumber,
                showCounter: $showCounter,
                selectedMine: $selectedMine,
                dismiss: dismiss,
                vm: vm,
                currentVM: currentVM
            )
        }
    }
}

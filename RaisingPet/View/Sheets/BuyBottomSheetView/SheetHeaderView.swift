//
//  SheetHeaderView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 13.06.2025.
//

import SwiftUI

// MARK: - Sheet Header
struct SheetHeaderView: View {
    let dismiss: DismissAction

    var body: some View {
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
    }
}

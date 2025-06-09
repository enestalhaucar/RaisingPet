//
//  RestoreButtonView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//

import SwiftUI

struct RestoreButtonView: View {
    var body: some View {
        ZStack {
            Text("shop_restore_button".localized())
                .font(.nunito(.medium, .caption12))
                .frame(height: 20)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .fill(.accent)
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                )
        }
    }
}

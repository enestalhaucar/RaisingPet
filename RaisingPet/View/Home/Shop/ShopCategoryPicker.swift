//
//  ShopCategoryPicker.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//

import SwiftUI
// MARK: - CategoryPicker

struct CategoryPicker: View {
    @Binding var selected: MainCategory
    // Production'da Diamonds gizlensin (bu hardcoded, istersen bir environment değişkeni ile kontrol edebilirsin)
    private let visibleCategories: [MainCategory] = [.diamonds, .pets] // Şu an sadece Pets görünecek

    var body: some View {
        HStack(spacing: 16) {
            ForEach(visibleCategories, id: \.self) { cat in
                Text(cat.rawValue.localized())
                    .font(.nunito(.bold, .callout14))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selected == cat
                                  ? Color.accentColor.opacity(0.1)
                                  : .white)
                            .overlay(
                              RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1)
                            )
                    )
                    .opacity(selected == cat ? 1 : 0.5)
                    .onTapGesture { selected = cat }
            }
        }
        .padding(.horizontal)
    }
}

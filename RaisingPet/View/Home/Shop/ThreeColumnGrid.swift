//
//  ThreeColumnGrid.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//

import SwiftUI

// MARK: - Generic 3-Column Grid

struct ThreeColumnGrid<Item, ID: Hashable, Content: View>: View {
    let items: [Item]
    let id: KeyPath<Item,ID>
    @ViewBuilder let content: (Item) -> Content

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: .init(.flexible()), count: 3),
            spacing: 16
        ) {
            ForEach(items, id: id) { item in
                content(item)
            }
        }
        .padding(.horizontal)
        .frame(width: Utilities.Constants.width)
    }
}

//
//  SectionHeader.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//

import SwiftUI

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title.localized())
            .font(.title3).bold()
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

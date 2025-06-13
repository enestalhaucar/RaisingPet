//
//  SectionHeaderView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 9.06.2025.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var isCollapsible: Bool = false
    @Binding var isExpanded: Bool

    // Add an initializer to handle the optional binding
    init(title: String, isCollapsible: Bool = false, isExpanded: Binding<Bool>? = nil) {
        self.title = title
        self.isCollapsible = isCollapsible
        self._isExpanded = isExpanded ?? .constant(true)
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
            Spacer()

            if isCollapsible {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .bold))
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 8)
    }
}

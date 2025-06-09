//
//  BackButtonView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//
import SwiftUI

struct BackButtonView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Image("arrow_back")
                .resizable()
                .frame(width: 20, height: 20)
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
        }.onTapGesture {
            dismiss()
        }
    }
}

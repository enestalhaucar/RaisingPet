//
//  EmptyEggStateView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 9.06.2025.
//

import SwiftUI

struct EmptyEggStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Option 1: Use a custom image if it exists in your assets
            // Image("emptyEgg")

            // Option 2: Use a more appropriate SF Symbol
            ZStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray.opacity(0.3))

                Image(systemName: "sparkles")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray.opacity(0.7))
            }

            Text("egg_empty_state_title".localized())
                .font(.title2)
                .foregroundColor(.gray)
            Text("egg_empty_state_subtitle".localized())
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
            NavigationLink(destination: ShopScreenView()) {
                Text("egg_empty_state_shop_button".localized())
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding(.vertical, 40)
    }
}

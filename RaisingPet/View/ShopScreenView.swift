//
//  ShopScreenView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 6.08.2024.
//

import SwiftUI

struct ShopScreenView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("shopBackgroundColor").ignoresSafeArea()
                
                VStack(spacing: 0.0) {
                    Image("shopRoof")
                        .resizable()
                        .frame(width: 367, height: 138)
                        .scaleEffect(1.1)
                        .offset(y: -15)
                    Spacer()
                }.ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ShopScreenView()
}

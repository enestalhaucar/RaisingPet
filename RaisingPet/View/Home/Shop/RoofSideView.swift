//
//  RoofSideView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//


import SwiftUI 
// MARK: - RoofSideView

struct RoofSideView: View {
    @EnvironmentObject var currentUser: CurrentUserViewModel
    var body: some View {
        ZStack {
            Image("shopRoof")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .ignoresSafeArea(edges: .top)
                .clipped()
            
            HStack(spacing: 16) {
                BackButtonView()
                    .padding(.leading, 16)
                
                AssetNumberView(iconName: "goldIcon", currencyType: .gold)
                AssetNumberView(iconName: "diamondIcon", currencyType: .diamond)
                Spacer()
                RestoreButtonView()
                    .padding(.trailing, 16)
            }.frame(width: ConstantManager.Layout.screenWidth)
            .padding(.top, 50)
        }
        .onAppear {
            Task {
                currentUser.refresh()
            }
        }
    }
}

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
                Color("shopBackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    RoofSideView()
                        .frame(maxWidth: .infinity)
                        .offset(y: -30)
                    
                    ShopCategoryView()
                    
                    
                    ShopItemsView().padding(.top, 25)
                    
                    Spacer()
                }
            }.ignoresSafeArea(edges : .top)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    ShopScreenView()
}

struct GoldView: View {
    var body: some View {
        ZStack {
            HStack(spacing: 5) {
                Image("goldIcon")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text("5")
                    .font(.nunito(.extraBold, .callout14))
                    .foregroundStyle(.accent)
                
                Image("plusIcon")
                    .resizable()
                    .frame(width: 10, height: 10)
            }
            .padding(.horizontal, 5)
            .frame(width: 75, height: 30)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .fill(.accent)
            )
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color("GoldBackgroundColor"))
            )
        }
    }
}

struct RoofSideView: View {
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
                GoldView()
                Spacer()
                RestoreButtonView()
                    .padding(.trailing, 16)
                
            }.frame(width: Utilities.Constants.width)
                
                .padding(.top, 50)
        }
    }
}

struct BackButtonView : View {
    var body: some View {
        ZStack {
            Image(systemName: "arrow.left")
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
        }
    }
}
struct RestoreButtonView : View {
    var body: some View {
        ZStack {
            Text("Restore")
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


struct ShopCategoryView : View {
    @State private var selectedCategory: String = "Pets"
    var body: some View {
        ZStack {
            HStack(spacing: 16) {
                ShopCategoryComponentView(isSelected: selectedCategory == "Pets", imageName: "pawIcon", text: "Pets").onTapGesture { selectedCategory = "Pets"}
                ShopCategoryComponentView(isSelected: selectedCategory == "Gold", imageName: "goldIcon", text: "Gold").onTapGesture { selectedCategory = "Gold"}
                ShopCategoryComponentView(isSelected: selectedCategory == "Home", imageName: "homeCategoryIcon", text: "Home").onTapGesture { selectedCategory = "Home"}
            }
        }
    }
}

struct ShopCategoryComponentView: View {
    var isSelected : Bool
    var imageName : String
    var text : String
    var body: some View {
        HStack(spacing: 3) {
            Image(imageName)
                .resizable()
                .frame(width: 20, height: 20)
            Text(text).font(.nunito(.bold, .callout14))
        }
        .padding(.vertical,10)
        .padding(.horizontal, 15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? .blue.opacity(0.1) : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 1)
                )
        )
        .opacity(isSelected ? 1 : 0.5 )
    }
}


struct ShopItemsView : View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body : some View {
        ZStack {
            LazyVGrid(columns: columns) {
                ForEach(0..<9) { _ in
                    ShopItemView(goldCost: 10, diamondCost: 20)
                        .background(Color.pink.opacity(0.3))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
            }.padding(.horizontal)
        }.frame(width: Utilities.Constants.width)
            
    }
}



struct ShopItemView: View {
    let goldCost: Int
    let diamondCost: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.05))
                .frame(width: 100, height: 120)

            VStack(spacing: 0) {
                Image("giftBox")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 120, height: 1)

                HStack(spacing: 5) {
                    Image("goldIcon")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("\(goldCost)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)

                    Text("/")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)

                    Image("diamondIcon")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("\(diamondCost)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.yellow.opacity(0.2))
                )
            }
        }
    }
}

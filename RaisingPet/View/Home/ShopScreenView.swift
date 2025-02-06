//
//  ShopScreenView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 6.08.2024.
//

import SwiftUI

struct ShopScreenView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        NavigationStack {
            ZStack {
                Color("shopBackgroundColor").ignoresSafeArea()
                
                Image("shopBackgroundImage")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .offset(y: -UIScreen.main.bounds.height / 2 + 150)
                
                ZStack {
                    Image("shopRoof")
                        .resizable()
                        .frame(height: 300)
                        .offset(y: -(UIScreen.main.bounds.height / 2) + 20)
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        Text("5")
                        Button(action: {
                            // Ekleme aksiyonu
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                    .foregroundStyle(.black)
                    .padding(8)
                    .frame(width: 100, height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color("shopBackgroundColor2")))
                    .offset(y: -(UIScreen.main.bounds.height / 2) + 40)
                }
                
                
                
                
                
                VStack {
                    
                    // İkinci Kısım (Pet, Gold, Asset, Home)
                    HStack(spacing: 12) {
                        HStack {
                            Image("pawIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Pet").font(.system(size: 12))
                        }
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("shopBackgroundColor2"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 2)
                                )
                        )
                        
                        HStack {
                            Image("goldIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Gold").font(.system(size: 12))
                        }
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("shopBackgroundColor2"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 2)
                                )
                        )
                        
                        HStack {
                            Image("assetIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Asset").font(.system(size: 12))
                        }
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("shopBackgroundColor2"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 2)
                                )
                        )
                        HStack {
                            Image("sofaIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Home").font(.system(size: 12))
                        }
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("shopBackgroundColor2"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 2)
                                )
                        )
                    }
                    .padding()
                    
                    // Üçüncü Kısım (Ödüller - Prize Grid)
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(0..<9) { _ in
                            VStack {
                                Image("giftBox")
                                    .resizable()
                                    .scaleEffect(1.5)
                                    .frame(width: 50, height: 50)
                                    .padding()
                                
                                
                                Text("Prize")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.pink.opacity(0.3))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        }
                    }
                    .padding()
                    
                    Spacer()
                }.padding(.top, 100)
                
            }.toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    ShopScreenView()
}

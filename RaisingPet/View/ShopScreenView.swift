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
                Image("shopRoof")
                    .resizable()
                    .scaleEffect(1.1)
                    .frame(height: 140)
                    .offset(y: -(UIScreen.main.bounds.height / 2) + 40)
                
                
                
                VStack {
                    // Üst Kısım (Dükkan Başlığı ve Menü)
                    HStack {
                        
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("5")
                            Button(action: {
                                // Ekleme aksiyonu
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                        
                        Spacer()
                        
                        Button(action: {
                            // Restore butonu aksiyonu
                        }) {
                            Text("Restore")
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                        }
                    }
                    .padding()
                    
                    // İkinci Kısım (Pet, Gold, Asset, Home)
                    HStack(spacing: 12) {
                        HStack {
                            Image("pawIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Pet").font(.system(size: 12))
                        }
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        
                        HStack {
                            Image("goldIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Gold").font(.system(size: 12))
                        }
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        
                        HStack {
                            Image("assetIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Asset").font(.system(size: 12))
                        }
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        HStack {
                            Image("sofaIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Home").font(.system(size: 12))
                        }
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    }
                    .padding(.horizontal)
                    
                    // Üçüncü Kısım (Ödüller - Prize Grid)
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(0..<9) { _ in
                            VStack {
                                Image("giftBox")
                                    .resizable()
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
                }
                .background(Color("shopBackgroundColor")) // Arka plan rengi
            }
            
        }
    }
}

#Preview {
    ShopScreenView()
}

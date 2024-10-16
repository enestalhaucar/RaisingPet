//
//  PetView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 21.08.2024.
//

import SwiftUI

struct PetView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("petScreenBackground")
                    .resizable()
                    .ignoresSafeArea()
                VStack() {
                    HStack(spacing: 10) {
                        VStack(spacing: 10) {
                            Image("getNewEgg").resizable()
                                .frame(width: 32, height: 32)
                            Text("Yeni Yumurta Al")
                                .font(.system(size: 12))
                        }
                        Spacer()
                        NavigationLink(destination: ShopScreenView()){
                            VStack(spacing: 10) {
                                Image("GoMarket")
                                Text("Markete Git")
                                    .font(.system(size: 12))
                            }
                        }
                        Spacer()
                        VStack(spacing: 10) {
                            Image("parent")
                            Text("Ebeveynlik Yap")
                                .font(.system(size: 12))
                        }
                    }.padding(.vertical)
                    
                    HStack {
                        Text("Yumurtalar")
                            .font(.system(size: 12))
                            .bold()
                        Spacer()
                        Image(systemName: "ellipsis")
                    }.padding(.vertical)
                    
                    HStack {
                        
                        NavigationLink(destination: PetCareView()) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 80, height: 90)
                                .foregroundStyle(Color("EggBackgroundColor"))
                                
                                Image("pet")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                        Spacer()
                        NavigationLink(destination: PetCareView()) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 80, height: 90)
                                .foregroundStyle(Color("EggBackgroundColor"))
                                
                                Image("pet")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                        Spacer()
                        NavigationLink(destination: PetCareView()) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 80, height: 90)
                                .foregroundStyle(Color("EggBackgroundColor"))
                                
                                Image("pet")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                        
                    }.padding(.horizontal )
                    
                    HStack {
                        Text("Sahiplendiklerin")
                            .font(.system(size: 12))
                            .bold()
                        Spacer()
                        Image(systemName: "ellipsis")
                    }.padding(.vertical)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 80, height: 90)
                            .foregroundStyle(Color("EggBackgroundColor"))
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 80, height: 90)
                            .foregroundStyle(Color("EggBackgroundColor"))
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 80, height: 90)
                            .foregroundStyle(Color("EggBackgroundColor"))
                        
                    }.padding(.horizontal )
                    
                    
                    Spacer()
                    
                }.padding(.horizontal)
                    .navigationTitle("Pet Screen")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
            }.toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    PetView()
}

//
//  FriendsView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 6.08.2024.
//

import SwiftUI

struct FriendsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()
                
                VStack {
                    HStack {
                        Circle().frame(width: 60, height: 60)
                        
                        Text("Sydney")
                            .font(.title2)
                        
                        Spacer()
                        
                        Image("friendsQRCode")
                    }.padding(.horizontal)
                        .padding(.trailing)
                        .padding()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(Color("friendsViewbuttonColor"))
                        
                        VStack(spacing: 10) {
                            Text("Favorite Person")
                            Image(systemName: "heart")
                            Text("Favorite Person")
                        }
                    }.frame(width: UIScreen.main.bounds.width * 9 / 10, height: 150)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(Color("friendsViewbuttonColor"))
                        HStack {
                            Image(systemName: "shared.with.you")
                            Spacer()
                            VStack {
                                Text("Share & Invite")
                                    .font(.system(size: 12))
                                    .bold()
                                Text("#3242387463")
                                    .font(.system(size: 12))
                                    .bold()
                            }
                        }.padding()
                            .padding(.horizontal)
                    }
                    .padding(.top,25)
                    .frame(width: UIScreen.main.bounds.width * 5 / 10, height: 50)
                    
                    
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image(systemName: "person.badge.plus")
                                .foregroundStyle(.white)
                            Text("Add Friends")
                                .foregroundStyle(.white)
                                .font(.title2)
                        }.frame(width: UIScreen.main.bounds.width * 9 / 10, height: 60)
                            .background(Color("friendsViewbuttonColor"), in: .rect(cornerRadius: 25))
                    })
                    
                    
                }
            }.toolbar(.hidden, for: .tabBar)
            .navigationTitle("Friends & Relations")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FriendsView()
}

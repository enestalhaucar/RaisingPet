//
//  HomeView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 5.08.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()
                
                VStack() {
                    
                    Image("homeViewPet")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(.vertical, 25)
                    
                    HStack(spacing: 25) {
                        VStack {
                            NavigationLink {
                                ShopScreenView()
                            } label: {
                                VStack{
                                    Image("shopIcon")
                                    Text("Shop")
                                        .bold()
                                }
                            }
                            
                        }
                        VStack {
                            NavigationLink {
                                FriendsView()
                            } label: {
                                VStack{
                                    Image("friendsIcon")
                                    Text("Friends").bold()
                                }
                            }
                        }
                        VStack {
                            NavigationLink {
                                PetCareView()
                            } label: {
                                VStack{
                                    Image("petIcon")
                                    Text("Pet").bold()
                                }
                            }
                        }
                        VStack {
                            NavigationLink {
                                NoteView()
                            } label: {
                                VStack{
                                    Image("noteIcon")
                                    Text("Note").bold()
                                }
                            }
                        }
                        
                        
                    }
                    
                    ZStack {
                        Image("homeViewNewRect")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 9 / 10, height: 75)
                        Text("News")
                    }
                    
                    Spacer()
                    
                    
                }.toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Image("squareBtn")
                            Text("Stacks")
                        }
                        
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Image("questionMarkBtn")
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Image("Petiverse")
                                .resizable()
                                .frame(width: 32, height: 32)
                            Text("Petiverse").bold()
                        }
                    }
                }
            }.navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    HomeView()
}

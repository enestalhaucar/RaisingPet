//
//  HomeView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 5.08.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color("mainbgColor").ignoresSafeArea()
            
            VStack() {
                
                Image("homeViewCat")
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
                        Image("petIcon")
                        Text("Pet").bold()
                    }
                    VStack {
                        Image("emotionsIcon")
                        Text("Emotions").bold()
                    }
                    
                    
                }
                
                ZStack {
                    Image("homeViewNewRect")
                    Text("News")
                }
                
                Spacer()
                
                
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image("squareBtn")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Image("questionMarkBtn")
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text("Raising Pet").bold()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

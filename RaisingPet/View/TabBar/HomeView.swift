//
//  HomeView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 5.08.2024.
//

import SwiftUI

struct HomeView: View {
    @State private var CountDownItem: CountDownWidgetOne =
    CountDownWidgetOne(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date())
    
    @State private var DistanceItem : DistanceWidget = DistanceWidget(bgSelected: true, backgroundImage: Image("backgroundImageForDistance"), backgroundColor: .green.opacity(0.3), textColor: .white, size: .small, title: "")
    @State private var DistanceItem2 : DistanceWidget = DistanceWidget(bgSelected: true, backgroundImage: Image("backgroundImageForDistance"), backgroundColor: .green.opacity(0.3), textColor: .white, size: .medium, title: "")
    
    @State private var AlbumItem : AlbumWidget = AlbumWidget(backgroundImage: [Image("profile1")], size: widgetSizeOne.small)
    @State private var AlbumItem2 : AlbumWidget = AlbumWidget(backgroundImage: [Image("profile2")], size: widgetSizeOne.small)
    
    
    @State private var targetDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 23) // Default 23 days later
    @State private var timeRemaining: (days: Int, hours: Int, minutes: Int) = (0, 0, 0)
    @State private var title : String = "To Maldives"
    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        HomePetSection()
                        
                        HomeNavigationButtons()
                        
                        HomeNewsSection()
                        
                        
                        
                        VStack {
                            HStack {
                                Text("Hot Widgets 🔥")
                                    .font(.title3)
                                    .bold()
                                Spacer()
                            }
                            
                            HStack {
                                NavigationLink(destination: CountDownSettingsView()) {
                                    ZStack {
                                        CountDownWidgetPreviewDesignOne(item: CountDownItem, targetDate: $targetDate, timeRemaining: timeRemaining, title: $title)
                                    }
                                }
                                NavigationLink(destination: DistanceSettingsView()) {
                                    ZStack {
                                        DistanceWidgetPreviewDesignOne(item: DistanceItem, title: $title)
                                    }
                                }
                            }
                            
                            NavigationLink(destination: DistanceSettingsView()) {
                                ZStack {
                                    DistanceWidgetPreviewDesignOne(item: DistanceItem2, title: $title)
                                }
                            }
                            
                            HStack {
                                NavigationLink(destination: AlbumSettingsView()) {
                                    ZStack {
                                        AlbumWidgetPreviewDesign(item: AlbumItem)
                                    }
                                }
                                NavigationLink(destination: AlbumSettingsView()) {
                                    ZStack {
                                        AlbumWidgetPreviewDesign(item: AlbumItem2)
                                    }
                                }
                                
                            }
                            
                            
                            
                        }.frame(width: UIScreen.main.bounds.width * 9 / 10)
                        Spacer()
                        
                        
                        
                        
                    }.toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                                NavigationLink(destination: MyWidgetsView()) {
                                    HStack {
                                        Image("squareBtn")
                                        Text("Stacks")
                                    }
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
                    .padding(.top,30)
                    
                }.scrollIndicators(.hidden)
            }.navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    HomeView()
}

struct CustomNavigationLink<Destination: View> : View {
    let view : Destination
    var imageName : String
    var text : String
    
    var body: some View {
        VStack {
            NavigationLink {
                view
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 65, height: 65)
                        .foregroundStyle(.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray.opacity(0.3))
                        }
                    VStack(spacing: 1) {
                        Image("\(imageName)")
                            .scaleEffect(0.8)
                        Text("\(text)")
                            .bold()
                    }
                }
            }
            
        }
    }
}

struct HomePetSection: View {
    var body: some View {
        NavigationLink(destination: PetView()) {
            ZStack {
                Image("petBackgroundImage")
                    .resizable(resizingMode: .tile)
                    .opacity(0.3)
                    .foregroundStyle(.white)
                
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.gray.opacity(0.3), lineWidth: 2)
                    }
                
                Image("pet")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .padding(.vertical, 25)
            }.frame(width: UIScreen.main.bounds.width * 9 / 10, height: 150)
        }
        
    }
}

struct HomeNavigationButtons: View {
    var body: some View {
        HStack(spacing: 25) {
            CustomNavigationLink(view: ShopScreenView(), imageName: "shopIcon", text: "Shop")
            CustomNavigationLink(view: FriendsView(), imageName: "friendsIcon", text: "Friends")
            CustomNavigationLink(view: PetView(), imageName: "petIcon", text: "Pet")
            VStack {
                NavigationLink {
                    NoteView()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 65, height: 65)
                            .foregroundStyle(.white)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray.opacity(0.3))
                            }
                        VStack(spacing: 1) {
                            Image("notesIcon")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .scaleEffect(0.8)
                            Text("Notes")
                                .bold()
                        }
                    }
                }
                
            }
        }
    }
}

struct HomeNewsSection: View {
    var body: some View {
        ZStack {
            Image("homeViewNewRect")
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 9 / 10, height: 75)
            Text("News").bold()
        }
    }
}

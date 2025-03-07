//
//  HomeView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 5.08.2024.
//

import SwiftUI

struct NavigationItem {
    let title : String?
    let imageName : String?
    let subTitle : String?
    let destination : AnyView?
}


struct HomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        HomePetSection()
                        
                        HomeNavigationButtons()
                        
                        HomeNewsSection()
                        
                        WidgetsPreviewSection()
                        
                        WidgetsNavigationSection()   
                        
                    }.toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink(destination: MyWidgetsView()) {
                                HStack {
                                    Image("squareBtn")
                                    Text("Stacks").font(.nunito(.semiBold, .callout14))
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
                            .font(.nunito(.semiBold, .callout14))
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
                    .resizable()
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
                                .font(.nunito(.semiBold, .callout14))
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

struct WidgetsPreviewSection: View {
    let navigationItemsForWidget : [NavigationItem] = [
        NavigationItem(title: "Pets", imageName: nil, subTitle: "Co-parenting with your pet", destination: AnyView(CountDownSettingsView())),
        NavigationItem(title: "Daily Frequence", imageName: nil, subTitle: "Co-parenting with your pet", destination: AnyView(DistanceSettingsView())),
        NavigationItem(title: "Distance", imageName: nil, subTitle: "Co-parenting with your pet", destination: AnyView(CountDownSettingsView())),
        NavigationItem(title: "Pin It!", imageName: nil, subTitle: "Co-parenting with your pet", destination: AnyView(DistanceSettingsView())),
        NavigationItem(title: "Send Emotions!", imageName: nil, subTitle: "Co-parenting with your pet", destination: AnyView(DistanceSettingsView())),
        NavigationItem(title: "Pet Care", imageName: nil, subTitle: "Co-parenting with your pet", destination: AnyView(DistanceSettingsView())),
        NavigationItem(title: "Draw", imageName: nil, subTitle: "Co-parenting with your pet", destination: AnyView(DistanceSettingsView())),
        NavigationItem(title: "Daily", imageName: nil, subTitle: "Co-parenting with your pet", destination: AnyView(DistanceSettingsView()))
    ]
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Hot Widgets 🔥")
                    .font(.nunito(.bold, .title320))
                Spacer()
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                ForEach(navigationItemsForWidget, id: \.title) { item in
                    NavigationLink(destination: AnyView(item.destination)) {
                        ZStack {
                            PreviewDesignComponent(title: item.title ?? "-", subTitle: item.subTitle ?? "-")
                        }
                    }
                }
            }
        }.frame(width: UIScreen.main.bounds.width * 9 / 10)
    }
}

struct WidgetsNavigationSection : View {
    let navigationItems : [NavigationItem] = [
        NavigationItem(title: "Signal", imageName: "signalIcon", subTitle: nil, destination: nil),
        NavigationItem(title: "Countdown", imageName: "countDownIcon", subTitle: nil, destination: nil),
        NavigationItem(title: "X-panel", imageName: "signalIcon", subTitle: nil, destination: nil),
        NavigationItem(title: "Photo", imageName: "photoIcon", subTitle: nil, destination: nil)
    ]
    var body: some View {
        ZStack {
            Color("navigationHomeViewBackgroundColor")
            VStack {
                ForEach(navigationItems, id: \.title) { item in
                    HStack {
                        Image(item.imageName ?? "")
                            .resizable()
                            .frame(width: 28, height: 28)
                        Text(item.title ?? "-")
                            .font(.nunito(.semiBold, .callout14))
                        Spacer()
                        Image("arrowIcon")
                            .resizable()
                            .frame(width: 26, height: 26)
                    }.padding(.horizontal)
                        .padding(.vertical, 4)
                    Divider()
                }
            }.padding(12)
        }.background(RoundedRectangle(cornerRadius: 10).stroke(Color("navigationHomeViewBorderColor"), lineWidth: 1))
            .padding(.horizontal)
    }
}

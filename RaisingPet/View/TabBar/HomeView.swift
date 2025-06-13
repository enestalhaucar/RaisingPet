//
//  HomeView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 5.08.2024.
//

import SwiftUI

struct NavigationItem {
    let title: String?
    let imageName: String?
    let subTitle: String?
    let destination: AnyView?
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()

                ScrollView {
                    VStack {

                        HomePetSection(viewModel: viewModel)

                        HomeNavigationButtons()

                        HomeNewsSection()

                        WidgetsPreviewSection()

                        WidgetsNavigationSection()

                    }.toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink(destination: EmptyView()) {
                                HStack {
                                    Image("squareBtn")
                                    Text("home_stacks".localized())
                                        .font(.nunito(.semiBold, .callout14))
                                }
                            }
                        }

                        ToolbarItem(placement: .topBarTrailing) {
                            Image("questionMarkBtn")
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            HStack {
                                Image("appIcon")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                Text("home_petiverse".localized())
                                    .bold()
                            }
                        }
                    }
                    .padding(.top, 30)

                }.scrollIndicators(.hidden)
            }.navigationBarBackButtonHidden()
        }
        .onAppear {
            Task {
                await viewModel.fetchInitialData()
            }
        }
    }
}

#Preview {
    HomeView()
}

struct CustomNavigationLink<Destination: View>: View {
    let view: Destination
    var imageName: String
    var text: String

    var body: some View {
        VStack {
            NavigationLink {
                view
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 65, height: 65)
                        .foregroundStyle(Color("homeNavigationSectionBackgroundColor"))
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
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                // Yükleniyor durumu
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.secondary.opacity(0.1))
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: UIScreen.main.bounds.width * 9 / 10, height: 150)
                    ProgressView()
                }
            } else if let pet = viewModel.petToDisplay {
                // Hayvan var durumu
                NavigationLink(destination: PetCareView(pet: pet)) {
                    PetDisplayView(imageName: pet.petType.name.lowercased())
                }
            } else if let egg = viewModel.eggToDisplay {
                // Yumurta var durumu
                NavigationLink(destination: EggAndPetsView()) {
                    PetDisplayView(imageName: egg.itemId.name)
                }
            } else {
                // Hiçbir şey yok durumu
                NavigationLink(destination: ShopScreenView()) {
                    PetDisplayView(imageName: "Egg") // Varsayılan yumurta görseli
                }
            }
        }
    }
}

// Tekrarlanan ZStack yapısını önlemek için yardımcı View
struct PetDisplayView: View {
    let imageName: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .stroke(.gray.opacity(0.3), lineWidth: 2)
                .frame(width: UIScreen.main.bounds.width * 9 / 10, height: 150)

            Image("petBackgroundImage")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 9 / 10, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 25))

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.vertical, 25)
        }
    }
}

struct HomeNavigationButtons: View {
    var body: some View {
        HStack(spacing: 25) {
            CustomNavigationLink(view: ShopScreenView(), imageName: "shopIcon", text: "shop".localized())
            CustomNavigationLink(view: FriendsView(), imageName: "friendsIcon", text: "friends".localized())
            CustomNavigationLink(view: EggAndPetsView(), imageName: "petIcon", text: "pet".localized())
            CustomNavigationLink(view: NoteView(), imageName: "noteIcon", text: "notes".localized())
        }
    }
}

struct HomeNewsSection: View {
    var body: some View {
        ZStack {
            Image("homeViewNewRect")
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 9 / 10, height: 75)
            Text("news".localized()).bold()
        }
    }
}

struct WidgetsPreviewSection: View {
    let navigationItemsForWidget: [NavigationItem] = [
        NavigationItem(title: "pets".localized(), imageName: nil, subTitle: "widgets_pets_subtitle".localized(), destination: AnyView(CountDownSettingsView()))
    ]
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("hot_widgets".localized())
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

struct WidgetsNavigationSection: View {
    @EnvironmentObject var currentVM: CurrentUserViewModel
    let navigationItems: [NavigationItem] = [
        NavigationItem(title: "widgets_signal".localized(), imageName: "signalIcon", subTitle: nil, destination: nil),
        NavigationItem(title: "widgets_countdown".localized(), imageName: "countDownIcon", subTitle: nil, destination: nil),
        NavigationItem(title: "widgets_x_panel".localized(), imageName: "signalIcon", subTitle: nil, destination: nil),
        NavigationItem(title: "widgets_photo".localized(), imageName: "photoIcon", subTitle: nil, destination: nil)
    ]
    var body: some View {
        ZStack {
//            Color("navigationHomeViewBackgroundColor")
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
            .onAppear {
                Task {
                    currentVM.refresh()
                }
            }
    }
}

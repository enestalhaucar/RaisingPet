//
//  FriendsView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 6.08.2024.
//

import SwiftUI
import Combine
import Alamofire

struct FriendsView: View {
    @StateObject var viewModel = FriendsViewModel()
    @State private var userDetails: [String: String] = [:]

    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()
                
                VStack {
                    HStack {
                        Circle().frame(width: 60, height: 60)
                        Text(userDetails["firstname"] ?? "N/A")
                            .font(.nunito(.medium, .title320))
                        
                        Spacer()
                    }.padding(.top)
                    .padding(.trailing)

                    
                    HStack {
                        Text("Your Friends")
                            .font(.nunito(.medium, .title320))
                            .padding(.top, 10)
                        Spacer()
                    }
                    
                    ScrollView {
                        ForEach(viewModel.friends, id: \._id) { friend in
                            FriendRow(friend: friend)
                                .padding(.vertical, 5)
                        }
                    }
                    
                    Spacer()
                    
                    // Yeni Arkadaş Ekle Butonu
                    Button(action: {
                        // Arkadaş ekleme işlemi
                    }, label: {
                        HStack {
                            Image(systemName: "person.badge.plus")
                                .foregroundStyle(.white)
                            Text("Add Friends")
                                .foregroundStyle(.white)
                                .font(.title2)
                        }
                        .frame(width: UIScreen.main.bounds.width * 9 / 10, height: 60)
                        .background(Color("friendsViewbuttonColor"), in: .rect(cornerRadius: 25))
                    })
                }.padding(.horizontal)
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("Friends & Relations")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchFriends()
                userDetails = Utilities.shared.getUserDetailsFromUserDefaults()
            }
        }
    }
}

struct FriendRow: View {
    let friend: Friend
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 21)
                .foregroundStyle(.blue.opacity(0.05))
            
            HStack {
                Circle()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(.gray)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundStyle(.gray)
                    )
                VStack(alignment: .leading) {
                    Text(friend.friend.firstname)
                        .font(.nunito(.medium, .title320))
                    Text(friend.friend.surname)
                        .font(.nunito(.medium, .title320))
                        .foregroundStyle(.gray)
                }
                Spacer()
                switch friend.status {
                case .accepted:
                    Image("ringBellIcon")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Image("pencilIcon")
                        .resizable()
                        .frame(width: 18, height: 18)
                case .pending:
                    Image(systemName: "hourglass")
                        .foregroundStyle(.orange)
                case .rejected:
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                }
            }
            .padding(10)
        }
        .frame(height: 110)
    }
}

#Preview {
    FriendsView()
}

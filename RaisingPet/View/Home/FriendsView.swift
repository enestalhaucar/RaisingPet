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
    @State private var showSearchFriend : Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()
                
                VStack(spacing: 25) {
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
                    
                    if !viewModel.friends.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "person.2.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("no_friends_title".localized())
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            // Açıklama
                            Text("no_friends_subtitle".localized())
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("Arkadaşlar")
                    } else {
                        ForEach(viewModel.friends, id: \._id) { friend in
                            FriendRow(friend: friend)
                                .padding(.vertical, 5)
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                    if !viewModel.friends.isEmpty {
                        // Yeni Arkadaş Ekle Butonu
                        Button(action: {
                            showSearchFriend = true
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
                    }
                }.padding(.horizontal)
            }
            .sheet(isPresented: $showSearchFriend) {
                SearchFriendView()
                    .presentationDetents([.height(Utilities.Constants.heightFour)])
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("friends_relations")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchFriendsList()
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

//#Preview {
//    FriendsView()
//}

struct SearchFriendView : View {
    @State private var searchText = ""
    @StateObject var viewModel = FriendsViewModel()
    var body: some View {
        VStack(spacing: 16) {
            Text("Arkadaş Ara")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.top, 16)
            
            TextField("Kullanıcı adı gir", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .frame(height: 40)
            
            
            HStack {
                Circle().frame(width: 60, height: 60)
                VStack {
                    Text(viewModel.searchedFriend.firstname)
                        .font(.nunito(.medium, .title320))
                    Text(viewModel.searchedFriend.surname)
                        .font(.nunito(.medium, .body16))
                }
                Spacer()
            }.padding()
                
            
            Spacer()
            
            Button {
                viewModel.searchFriendWithTag(searchText)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12).foregroundStyle(.yellow.opacity(0.3))
                    
                    Text("Send Invite")
                        .font(.nunito(.medium, .body16))
                }.padding(.horizontal)
                    .frame(height: 55)
            }
            
            
                
            

            
            
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

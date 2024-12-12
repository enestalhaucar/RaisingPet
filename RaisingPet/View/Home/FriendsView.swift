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
                    // Kullanıcı Bilgisi
                    HStack {
                        Circle().frame(width: 60, height: 60)
                        
                        Text(userDetails["firstname"] ?? "N/A")
                            .font(.title2)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.trailing)
                    .padding()
                    
                    // Arkadaş Listesi Başlığı
                    Text("Your Friends")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    // Arkadaş Listesi
                    ScrollView {
                        ForEach(viewModel.friends, id: \._id) { friend in
                            FriendRow(friend: friend)
                                .padding(.horizontal)
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
                }
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
        HStack {
            // Fotoğraf veya Placeholder
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(.gray)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundStyle(.white)
                )
            
            // Ad ve Soyad
            VStack(alignment: .leading) {
                Text(friend.friend.firstname)
                    .font(.headline)
                Text(friend.friend.surname)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
            
            // Duruma Göre İkon
            switch friend.status {
            case .accepted:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            case .pending:
                Image(systemName: "hourglass")
                    .foregroundStyle(.orange)
            case .rejected:
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.red)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    FriendsView()
}

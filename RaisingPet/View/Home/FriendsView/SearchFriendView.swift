//
//  SearchFriendView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 9.05.2025.
//

import SwiftUI

struct SearchFriendView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SearchFriendViewModel()
    @State private var showingShareSheet = false

    var onFriendRequestSent: () -> Void
    let userFriendTag: String

    var body: some View {
        VStack(spacing: 16) {
            // Başlık ve Sağ Üst Butonlar
            HStack {
                Text("search_friend_title".localized())
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    showingShareSheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.gray)
                        Text("search_friend_share".localized())
                            .font(.nunito(.medium, .body16))
                            .foregroundStyle(.gray)
                    }
                }
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal)

            TextField("search_friend_placeholder".localized(), text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .frame(height: 40)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            // Arama Sonucu
            if viewModel.isLoading {
                ProgressView()
            } else if let searchedUser = viewModel.searchedFriend {
                HStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.gray)
                        )
                    VStack(alignment: .leading) {
                        Text("\(searchedUser.firstname) \(searchedUser.surname)")
                            .font(.nunito(.medium, .title320))
                        Text(searchedUser.friendTag)
                            .font(.nunito(.regular, .body16))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
            } else if !viewModel.searchText.isEmpty {
                Text(viewModel.errorMessage ?? "search_friend_not_found".localized())
                    .font(.nunito(.medium, .body16))
                    .foregroundColor(.secondary)
            } else {
                 Text("search_friend_empty_search".localized())
                    .font(.nunito(.medium, .body16))
                    .foregroundColor(.secondary)
            }

            Spacer() // İçeriği yukarıya itmek için

            // Arkadaşı Ekle Butonu
            Button(action: {
                if let userToAdd = viewModel.searchedFriend {
                    Task {
                        let success = await viewModel.sendFriendRequest(friendId: userToAdd.id)
                        if success {
                            onFriendRequestSent()
                            dismiss()
                        }
                    }
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(viewModel.searchedFriend == nil ? Color(.systemGray4) : Color.green.opacity(0.6))
                    Text("search_friend_add_button".localized())
                        .font(.nunito(.medium, .body16))
                        .foregroundColor(viewModel.searchedFriend == nil ? .gray : .white)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                .frame(height: 55)
            }
            .disabled(viewModel.searchedFriend == nil)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .alert(isPresented: .init(get: { viewModel.errorMessage != nil && viewModel.searchedFriend == nil }, set: { _ in viewModel.errorMessage = nil })) {
            Alert(
                title: Text("friends_error_title".localized()),
                message: Text(viewModel.errorMessage ?? "friends_unknown_error".localized()),
                dismissButton: .default(Text("friends_alert_ok".localized()))
            )
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: ["Benimle arkadaş olur musun? İşte tag'im: \(userFriendTag) - Bu linke tıklayarak arkadaşlık isteğimi kabul edebilirsin: raisingpet://friends?tag=\(userFriendTag)"])
        }
    }
}

//
//  SearchFriendView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 9.05.2025.
//

import SwiftUI

struct SearchFriendView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var showingShareSheet = false
    @ObservedObject var viewModel: FriendsViewModel
    let userFriendTag: String

    var body: some View {
        VStack(spacing: 16) {
            // Başlık ve Sağ Üst Butonlar
            HStack {
                Text("Arkadaş Ara")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    showingShareSheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.gray)
                        Text("Share")
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

            TextField("Kullanıcı tag’ini gir (ör: ÖmerDuman#5368)", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .frame(height: 40)
                .onChange(of: searchText) { newValue in
                    // Debounce ekleyerek her harf değişikliğinde istek atmayı optimize edelim
                    Task {
                        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 saniye bekle
                        if !newValue.isEmpty {
                            await viewModel.searchFriendWithTag(newValue)
                        } else {
                            viewModel.searchedFriend = .init(id: "", firstname: "", surname: "", email: "", photo: "", role: "", gameCurrencyGold: 0, gameCurrencyDiamond: 0, friendTag: "", v: 0)
                        }
                    }
                }

            // Arama Sonucu
            if !viewModel.searchedFriend.id.isEmpty {
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
                        Text("\(viewModel.searchedFriend.firstname) \(viewModel.searchedFriend.surname)")
                            .font(.nunito(.medium, .title320))
                        Text(viewModel.searchedFriend.friendTag)
                            .font(.nunito(.regular, .body16))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
            } else if searchText.isEmpty {
                Text("Bir tag girerek arkadaş ara.")
                    .font(.nunito(.medium, .body16))
                    .foregroundColor(.secondary)
            } else {
                Text("Arkadaş bulunamadı.")
                    .font(.nunito(.medium, .body16))
                    .foregroundColor(.secondary)
            }

            // Arkadaşı Arat / Arkadaşı Ekle Butonu
            Button(action: {
                if !viewModel.searchedFriend.id.isEmpty {
                    // Kullanıcı bulunduysa, arkadaşlık isteği gönder
                    Task {
                        do {
                            try await viewModel.sendFriendRequest(friendId: viewModel.searchedFriend.id)
                            dismiss() // İstek gönderildikten sonra sheet’i kapat
                        } catch {
                            print("Send friend request error: \(error)")
                        }
                    }
                } else {
                    // Kullanıcı bulunmadıysa, aramayı tekrar tetikle
                    Task {
                        if !searchText.isEmpty {
                            await viewModel.searchFriendWithTag(searchText)
                        }
                    }
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(viewModel.searchedFriend.id.isEmpty ? .yellow.opacity(0.3) : .blue.opacity(0.7))
                    Text(viewModel.searchedFriend.id.isEmpty ? "Arkadaşı Arat" : "Arkadaşı Ekle")
                        .font(.nunito(.medium, .body16))
                        .foregroundColor(viewModel.searchedFriend.id.isEmpty ? .black : .white)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                .frame(height: 55)
            }

            // Paylaşım Sheet’i
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(activityItems: ["Benimle arkadaş olur musun? İşte tag’im: \(userFriendTag) - Bu linke tıklayarak arkadaşlık isteğimi kabul edebilirsin: raisingpet://friends?tag=\(userFriendTag)"])
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .alert(isPresented: .init(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
            Alert(title: Text("Hata"), message: Text(viewModel.errorMessage ?? "Bilinmeyen hata"), dismissButton: .default(Text("Tamam")))
        }
    }
}

//
//  FriendsView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.08.2024.
//

import SwiftUI
import Combine
import Alamofire

struct FriendsView: View {
    @StateObject var viewModel = FriendsViewModel()
    @State private var userDetails: [String: String] = [:]
    @State private var showSearchFriend: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var friendToDelete: Friend? // Silinecek arkadaşı tutmak için
    @State private var showCopyConfirmation: Bool = false // Kopyalama onayı için

    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()

                VStack(spacing: 25) {
                    // Kullanıcı Başlığı ve Friend Tag
                    profileHeader
                    
                    // Your Friends Başlığı
                    friendsTitle
                    
                    // Arkadaşlık İstekleri ve Arkadaş Listesi
                    if viewModel.acceptedFriends.isEmpty && viewModel.pendingFriends.isEmpty {
                        emptyFriendsView
                    } else {
                        friendsListView
                    }

                    Spacer()

                    // Add Friend Butonu (Sadece acceptedFriends boşken gösterilecek)
                    if viewModel.acceptedFriends.isEmpty {
                        addFriendButton
                    }
                }
                .padding(.horizontal)

                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .sheet(isPresented: $showSearchFriend) {
                SearchFriendView(viewModel: viewModel, userFriendTag: userDetails["friendTag"] ?? "N/A")
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.3)])
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("friends_relations".localized())
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchFriendsList()
                userDetails = Utilities.shared.getUserDetailsFromUserDefaults()
            }
            .alert(isPresented: $showDeleteConfirmation) {
                deleteConfirmationAlert
            }
            .alert("friends_tag_copied".localized(), isPresented: $showCopyConfirmation) {
                Button("friends_alert_ok".localized(), role: .cancel) {}
            }
            .alert(isPresented: .init(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
                errorAlert
            }
        }
    }
    
    // MARK: - Subviews
    
    private var profileHeader: some View {
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
                Text(userDetails["firstname"] ?? "N/A")
                    .font(.nunito(.medium, .title320))
                HStack {
                    Text(userDetails["friendTag"] ?? "N/A")
                        .font(.nunito(.regular, .body16))
                        .foregroundColor(.gray)
                    Button(action: {
                        UIPasteboard.general.string = userDetails["friendTag"]
                        showCopyConfirmation = true
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundStyle(.gray)
                            .frame(width: 16, height: 16)
                    }
                }
            }
            Spacer()
        }
        .padding(.top)
        .padding(.trailing)
    }
    
    private var friendsTitle: some View {
        HStack {
            Text("friends_your_friends".localized())
                .font(.nunito(.medium, .title320))
                .padding(.top, 10)
            Spacer()
        }
    }
    
    private var emptyFriendsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            Text("no_friends_title".localized())
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Text("no_friends_subtitle".localized())
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var friendsListView: some View {
        VStack {
            // Arkadaşlık İstekleri
            if !viewModel.pendingFriends.isEmpty {
                pendingFriendsView
            }

            // Arkadaşlar
            if !viewModel.acceptedFriends.isEmpty {
                acceptedFriendsView
            }
        }
    }
    
    private var pendingFriendsView: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.pendingFriends, id: \.id) { friend in
                FriendRow(
                    friend: friend, 
                    onAccept: {
                        acceptFriendRequest(friend: friend)
                    }, 
                    onReject: {
                        rejectFriendRequest(friend: friend)
                    }, 
                    onDelete: {
                        removeFriend(friend: friend)
                    }
                )
                .padding(.vertical, 5)
            }
            Spacer()
        }
    }
    
    private var acceptedFriendsView: some View {
        ForEach(viewModel.acceptedFriends, id: \.id) { friend in
            FriendRow(
                friend: friend, 
                onAccept: {}, 
                onReject: {}, 
                onDelete: {
                    friendToDelete = friend
                    showDeleteConfirmation = true
                }
            )
            .padding(.vertical, 5)
        }
    }
    
    private var addFriendButton: some View {
        Button(action: {
            showSearchFriend = true
        }) {
            HStack {
                Image(systemName: "person.badge.plus")
                    .foregroundStyle(.white)
                Text("friends_add_friend".localized())
                    .foregroundStyle(.white)
                    .font(.title2)
            }
            .frame(width: UIScreen.main.bounds.width * 9 / 10, height: 60)
            .background(Color("friendsViewbuttonColor"), in: .rect(cornerRadius: 25))
        }
    }
    
    private var deleteConfirmationAlert: Alert {
        Alert(
            title: Text("friends_delete_friend_title".localized()),
            message: Text("friends_delete_friend_message".localized()),
            primaryButton: .destructive(Text("friends_delete_button".localized())) {
                deleteSelectedFriend()
            },
            secondaryButton: .cancel(Text("friends_cancel_button".localized()))
        )
    }
    
    private var errorAlert: Alert {
        Alert(
            title: Text("friends_error_title".localized()),
            message: Text(viewModel.errorMessage ?? "friends_unknown_error".localized()),
            dismissButton: .default(Text("friends_alert_ok".localized()))
        )
    }
    
    // MARK: - Helper Methods
    
    private func acceptFriendRequest(friend: Friend) {
        Task {
            do {
                try await viewModel.acceptFriendRequest(requestId: friend.id)
            } catch {
                print("Accept error: \(error)")
            }
        }
    }
    
    private func rejectFriendRequest(friend: Friend) {
        Task {
            do {
                try await viewModel.rejectFriendRequest(requestId: friend.id)
            } catch {
                print("Reject error: \(error)")
            }
        }
    }
    
    private func removeFriend(friend: Friend) {
        Task {
            do {
                try await viewModel.removeFriend(friendId: friend.friend._id)
            } catch {
                print("Remove error: \(error)")
            }
        }
    }
    
    private func deleteSelectedFriend() {
        if let friend = friendToDelete {
            Task {
                do {
                    try await viewModel.removeFriend(friendId: friend.friend._id)
                } catch {
                    print("Remove friend error: \(error)")
                }
            }
        }
    }
}

struct FriendRow: View {
    let friend: Friend
    let onAccept: () -> Void
    let onReject: () -> Void
    let onDelete: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 21)
                .foregroundStyle(.blue.opacity(0.05))

            HStack {
                Circle()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.gray)
                    )
                VStack(alignment: .leading) {
                    Text("\(friend.friend.firstname) \(friend.friend.surname)")
                        .font(.nunito(.medium, .title320))
                    Text(friend.friend.friendTag)
                        .font(.nunito(.regular, .body16))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                friendStatusButtons
            }
            .padding(10)
        }
        .frame(height: 110)
    }
    
    @ViewBuilder
    private var friendStatusButtons: some View {
        switch friend.status {
        case "accepted":
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
                    .frame(width: 18, height: 18)
            }
        case "pending":
            if friend.friend.isSending {
                Image(systemName: "hourglass")
                    .foregroundStyle(.orange)
            } else {
                HStack {
                    Button(action: onAccept) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                    Button(action: onReject) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
        case "rejected":
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.red)
        default:
            EmptyView()
        }
    }
}

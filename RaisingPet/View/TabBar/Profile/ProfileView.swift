//
//  ProfileView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 14.08.2024.
//

import SwiftUI

struct ProfileView: View {
    @State private var isShowPremiumView = false
    @StateObject private var viewModel = ProfileViewModel()
    @State private var userDetails: [String: String] = [:]
    @EnvironmentObject var appState: AppState
    @State private var showCopiedMessage = false
    @State private var profileImage: UIImage?
    private let placeholderImage = UIImage(named: "placeholder")

    init() {
        _viewModel = StateObject(wrappedValue: ProfileViewModel())
    }

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(spacing: 10) {
                            if let image = viewModel.profileImage ?? profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            } else if let photoURLString = userDetails["photoURL"], !photoURLString.isEmpty, photoURLString != "N/A" {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 120, height: 120)

                                    if viewModel.isLoadingImage {
                                        ProgressView()
                                            .frame(width: 120, height: 120)
                                    } else {
                                        Image(uiImage: placeholderImage ?? UIImage())
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .shadow(radius: 10)
                                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                    }
                                }
                                .onAppear {
                                    Task {
                                        await viewModel.loadProfileImage(from: photoURLString)
                                    }
                                }
                            } else {
                                Image(uiImage: placeholderImage ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            }
                        }
                        // User name and tag
                        VStack {
                            Text("\(userDetails["firstname"] ?? "") \(userDetails["lastname"] ?? "")")
                                .font(.nunito(.semiBold, .body16))

                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("\(userDetails["friendTag"] ?? "")")
                                    .font(.nunito(.bold, .body16))
                                    .foregroundStyle(.blue)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                UIPasteboard.general.string = userDetails["friendTag"] ?? "It could not pasted on pasteboard."
                                showCopiedMessage = true
                            }
                        }

                        // Upgrade Premium Button
                        Button(action: {
                            isShowPremiumView = true
                        }) {
                            HStack {
                                Image("Diamond")
                                Text("profile_upgrade_premium".localized())
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                            .frame(width: UIScreen.main.bounds.width * 7 / 10)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(red: 255/255, green: 245/255, blue: 235/255))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(
                                                LinearGradient(gradient: Gradient(colors: [
                                                    Color(red: 94/255, green: 92/255, blue: 230/255),
                                                    Color(red: 255/255, green: 55/255, blue: 95/255),
                                                    Color(red: 255/255, green: 159/255, blue: 10/255)
                                                ]), startPoint: .leading, endPoint: .trailing),
                                                lineWidth: 2
                                            )
                                    )
                            )
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            Text("profile_section_title".localized())
                                .font(.nunito(.bold, .title320))
                                .padding(.bottom, 8)

                            VStack(alignment: .leading, spacing: 16) {
                                ProfileRow(iconName: "person.circle", title: "profile_row_title".localized())
                                Divider()
                                Row(iconName: "bell", title: "profile_notification".localized())
                                Divider()
                                LanguageRow(iconName: "globe", title: "profile_language".localized())
                                Divider()
                                Row(iconName: "gift", title: "profile_gift_card".localized())
                            }
                            .padding()
                            .background(Color("profileBackgroundColor"))
                            .cornerRadius(10)
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            Text("settings_section_title".localized())
                                .font(.nunito(.bold, .title320))
                                .padding(.bottom, 8)

                            VStack(alignment: .leading, spacing: 16) {
                                Row(iconName: "shield", title: "profile_authorize".localized())
                                Divider()
                                Row(iconName: "lock.circle", title: "profile_change_password".localized())
                                Divider()
                                Row(iconName: "link", title: "profile_linked_account".localized())
                                Divider()
                                LogOutRow(onLogout: {
                                    viewModel.logOut(appState: appState)
                                }, iconName: "arrow.right.to.line", title: "profile_log_out".localized())
                            }
                            .padding()
                            .background(Color("profileBackgroundColor"))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .navigationTitle("profile_screen_title".localized())
                    .navigationBarTitleDisplayMode(.inline)
                }
                .scrollIndicators(.hidden)
                .onAppear {
                    userDetails = viewModel.getUserDetailsForProfileView()
                    viewModel.loadProfileImageFromCache()

                    if let photoData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
                       let image = UIImage(data: photoData) {
                        profileImage = image
                    }
                }
                .onChange(of: isShowPremiumView) {
                    if !isShowPremiumView {
                        if let photoData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
                           let image = UIImage(data: photoData) {
                            profileImage = image
                        }
                        viewModel.loadProfileImageFromCache()
                    }
                }
            }

            ToastView(message: "friends_tag_copied".localized(), isShowing: $showCopiedMessage)
        }
        .fullScreenCover(isPresented: $isShowPremiumView) {
            PremiumView(isShow: $isShowPremiumView)
        }
    }
}

struct Row: View {
    var iconName: String
    var title: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 24, height: 24)
            Text(title)
                .font(.nunito(.medium, .body16))
            Spacer()
            Image("arrowIcon")
                .resizable()
                .frame(width: 26, height: 26)
                .foregroundColor(.gray)
        }
    }
}

struct LogOutRow: View {
    var onLogout: () -> Void
    var iconName: String
    var title: String
    @EnvironmentObject var appState: AppState

    var body: some View {
        Button(action: {
            onLogout()
        }) {
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.body)
                Spacer()
                Image("arrowIcon")
                    .resizable()
                .frame(width: 26, height: 26)
                .foregroundColor(.gray)
            }
        }
    }
}

struct LanguageRow: View {
    var iconName: String
    var title: String

    var body: some View {
        NavigationLink(destination: LanguageSelectionView()) {
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.body)
                Spacer()
                Image("arrowIcon")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct LanguageSelectionView: View {
    @State private var selectedLanguage: Languages = Localizable.currentLanguage
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(Array(Languages.allCases.enumerated()), id: \.element.hashValue) { (_, language) in
                        Button(action: {
                            Localizable.setCurrentLanguage(language)
                            selectedLanguage = language
                            appState.objectWillChange.send()
                            dismiss()
                        }) {
                            HStack {
                                Text(language.stringValue)
                                Spacer()
                                if selectedLanguage == language {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ProfileRow: View {
    var iconName: String
    var title: String

    var body: some View {
        NavigationLink(destination: ProfileEditView(isSuccess: .constant(false))) {
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.body)
                Spacer()
                Image("arrowIcon")
                .resizable()
                .frame(width: 26, height: 26)
                .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    LanguageSelectionView()
}

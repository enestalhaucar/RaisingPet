//
//  ProfileView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 14.08.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var isShowPremiumView = false
    @StateObject private var viewModel = ProfileViewModel()
    @State private var userDetails : [String:String] = [:]
    @EnvironmentObject var appState : AppState
    @State private var showCopiedMessage = false
    @State private var profileImage: UIImage? = nil
    private let placeholderImage = UIImage(named: "placeholder")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 10) {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
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
                                .onTapGesture {
                                    UIPasteboard.general.string = userDetails["friendTag"] ?? "It could not pasted on pasteboard."
                                    withAnimation {
                                        showCopiedMessage = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showCopiedMessage = false
                                        }
                                    }
                                }
                        }
                        
                    }
                    
                    // Upgrade Premium Button
                    Button(action: {
                        isShowPremiumView = true
                    }) {
                        HStack {
                            Image("Diamond")
                            // Metin
                            Text("Upgrade Premium")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }.frame(width: UIScreen.main.bounds.width * 7 / 10)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(red: 255/255, green: 245/255, blue: 235/255)) // İç dolgu rengi
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(
                                                LinearGradient(gradient: Gradient(colors: [
                                                    Color(red: 94/255, green: 92/255, blue: 230/255), // İlk renk: #5E5CE6
                                                    Color(red: 255/255, green: 55/255, blue: 95/255), // Orta renk: #FF375F
                                                    Color(red: 255/255, green: 159/255, blue: 10/255)  // Son renk: #FF9F0A
                                                ]), startPoint: .leading, endPoint: .trailing),
                                                lineWidth: 2 // Çerçeve kalınlığı
                                            )
                                    )
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Profile")
                            .font(.nunito(.bold, .title320))
                            .padding(.bottom, 8)
                        
                        // Arka plan
                        VStack(alignment: .leading, spacing: 16) {
                            // Her bir ayar öğesi
                            ProfileRow(iconName: "person.circle", title: "Profile")
                            Divider()
                            Row(iconName: "bell", title: "Notification")
                            Divider()
                            LanguageRow(iconName: "globe", title: "Language")
                            Divider()
                            Row(iconName: "gift", title: "Gift Card")
                        }.padding()
                            .background(Color("profileBackgroundColor")) // Mavi arka plan
                            .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Settings")
                            .font(.nunito(.bold, .title320))
                            .padding(.bottom, 8)
                        
                        // Arka plan
                        VStack(alignment: .leading, spacing: 16) {
                            // Her bir ayar öğesi
                            Row(iconName: "shield", title: "Authorize")
                            Divider()
                            Row(iconName: "lock.circle", title: "Change Password")
                            Divider()
                            Row(iconName: "link", title: "Linked Account")
                            Divider()
                            LogOutRow(onLogout: {
                                viewModel.logOut(appState: appState)
                            }, iconName: "arrow.right.to.line", title: "Log Out")
                        }
                        .padding()
                        .background(Color("profileBackgroundColor")) // Mavi arka plan
                        .cornerRadius(10)
                    }
                    
                    
                    
                    
                }.padding(.horizontal)
                    .navigationTitle("Profile Screen")
                    .navigationBarTitleDisplayMode(.inline)
            }.scrollIndicators(.hidden)
                .onAppear {
                    userDetails = viewModel.getUserDetailsForProfileView()
                }
        }.fullScreenCover(isPresented: $isShowPremiumView, content: {
            PremiumView(isShow: $isShowPremiumView)
        })
    }
}

struct Row: View {
    var iconName: String
    var title: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: iconName) // Sistem simgesi
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

struct LogOutRow : View {
    var onLogout: () -> Void // Çıkış sonrası tetiklenecek callback
    var iconName: String
    var title: String
    @EnvironmentObject var appState: AppState  // AppState erişimi
    var body: some View {
        Button(action: {
            onLogout()
        }, label: {
            HStack(spacing: 10) {
                Image(systemName: iconName) // Sistem simgesi
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
        })
    }
}

struct LanguageRow : View {
    var iconName: String
    var title: String
    
    var body: some View {
        NavigationLink(destination: LanguageSelectionView()) {
            HStack(spacing: 10) {
                Image(systemName: iconName) // Sistem simgesi
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

struct LanguageSelectionView : View {
    @State private var selectedLanguage: Languages = Localizable.currentLanguage
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(Array(Languages.allCases.enumerated()), id: \.element.hashValue) { (index, language) in
                        Button(action: {
                            Localizable.setCurrentLanguage(language)
                            selectedLanguage = language
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

struct ProfileRow : View {
    var iconName: String
    var title: String
    
    var body: some View {
        NavigationLink(destination: ProfileEditView(isSuccess: .constant(false))) {
            HStack(spacing: 10) {
                Image(systemName: iconName) // Sistem simgesi
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

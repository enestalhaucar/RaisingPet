//
//  ProfileView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 14.08.2024.
//

import SwiftUI

@MainActor
final class ProfileViewModel : ObservableObject {
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        print("User logged out successfully")
    }
    
    func getUserDetailsForProfileView() -> [String:String] {
        var userDetails : [String:String] = [:]
        let tempUserDetails = Utilities.shared.getUserDetailsFromUserDefaults()
        userDetails = tempUserDetails
        print("ProfileView UserDetails Fetched :  \(userDetails)")
        return userDetails
    }
    
}

struct ProfileView: View {
    @State private var isShowPremiumView = false
    @StateObject private var viewModel = ProfileViewModel()
    @State private var userDetails : [String:String] = [:]
    var onLogout: () -> Void // Çıkış sonrası tetiklenecek callback
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 10) {
                        Text(userDetails["token"] ?? "N/A")
                        Text(userDetails["firstname"] ?? "N/A")
                        Text(userDetails["surname"] ?? "N/A")
                        Text(userDetails["email"] ?? "N/A")
                        Text(userDetails["friendTag"] ?? "N/A")
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
                            .font(.system(size: 16))
                            .bold()
                            .padding(.bottom, 8)
                        
                        // Arka plan
                        VStack(alignment: .leading, spacing: 16) {
                            // Her bir ayar öğesi
                            ProfileRow(iconName: "person.circle", title: "Profile")
                            Divider()
                            Row(iconName: "bell", title: "Notification")
                            Divider()
                            Row(iconName: "globe", title: "Language")
                            Divider()
                            Row(iconName: "gift", title: "Gift Card")
                        }
                        
                        .padding()
                        .background(Color("profileBackgroundColor")) // Mavi arka plan
                        .cornerRadius(10)
                    }.frame(width: UIScreen.main.bounds.width * 8 / 10)
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Settings")
                            .font(.system(size: 16))
                            .bold()
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
                                viewModel.logOut()
                                onLogout()
                            }, iconName: "arrow.right.to.line", title: "Log Out")
                        }
                        
                        .padding()
                        .background(Color("profileBackgroundColor")) // Mavi arka plan
                        .cornerRadius(10)
                    }.frame(width: UIScreen.main.bounds.width * 8 / 10)
                        .padding()
                    
                    
                    
                }
                .navigationTitle("Profile Screen")
                .navigationBarTitleDisplayMode(.inline)
            }.scrollIndicators(.hidden).task {
//                try? await viewModel.loadCurrentUser()
            }
            .onAppear {
                userDetails = viewModel.getUserDetailsForProfileView()
            }
            
        }.fullScreenCover(isPresented: $isShowPremiumView, content: {
            PremiumView(isShow: $isShowPremiumView)
        })
    }
}

//#Preview {
//    ProfileView()
//
//}

struct Row: View {
    var iconName: String
    var title: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: iconName) // Sistem simgesi
                .resizable()
                .frame(width: 24, height: 24)
            Text(title)
                .font(.body)
            Spacer()
            Image(systemName: "chevron.right") // Sağ ok simgesi
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

struct LogOutRow : View {
    var onLogout: () -> Void // Çıkış sonrası tetiklenecek callback
    var iconName: String
    var title: String 
    @StateObject private var viewModel = ProfileViewModel()
    var body: some View {
        Button(action: {
            viewModel.logOut()
            onLogout()
        }, label: {
            HStack(spacing: 10) {
                Image(systemName: iconName) // Sistem simgesi
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.body)
                Spacer()
                Image(systemName: "chevron.right") // Sağ ok simgesi
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
        })
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
                Image(systemName: "chevron.right") // Sağ ok simgesi
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
    }
}

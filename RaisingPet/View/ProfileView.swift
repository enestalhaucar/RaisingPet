//
//  ProfileView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 14.08.2024.
//

import SwiftUI

@MainActor
final class ProfileViewModel : ObservableObject {
    @Published private(set) var user : DBUser? = nil
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if let user = viewModel.user {
                        Text("User ID: \(user.userId ?? "")")
                        Text("User email: \(user.email ?? "")")
                        
                        if let dateCreated = user.dateCreated {
                            Text("Date Created : \(dateCreated.description)")
                        }
                    }
                    Text("Hello")
                    
                }
            }.task {
                try? await viewModel.loadCurrentUser()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView(isSuccess: .constant(true))) {
                        Image(systemName: "gear")
                            .font(.headline)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()

}

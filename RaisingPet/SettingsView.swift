//
//  SettingsView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 30.07.2024.
//

import SwiftUI

@MainActor
final class SettingsViewModel : ObservableObject {
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
        
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var isSuccess : Bool
    var body: some View {
        ZStack {
            SignInUpBackground()
            
            VStack {
                List {
                    Button {
                        Task {
                            do {
                                try viewModel.logOut()
                                print("loggedout")
                                isSuccess = true
                                
                            }
                            catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Log Out")
                    }

                }
            }
        }
    }
}

#Preview {
    SettingsView(isSuccess: .constant(false))
}

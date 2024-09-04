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
        NavigationStack {
            ZStack {
                Color("mainbgColor")
                    .ignoresSafeArea()
                
                VStack() {
                    ScrollView {
                        HStack {
                            Text("Account")
                                .padding(.leading,25)
                            Image(systemName: "arrow.down")
                            
                            Spacer()
                        }
                        NavigationLink(destination: AccountView()) {
                            SettingsButtonComp(imageName: "person", title: "Account")
                            
                        }
                        
                        NavigationLink(destination: EmptyView()) {
                            SettingsButtonComp(imageName: "envelope", title: "Mail")
                            
                        }
                        
                        NavigationLink(destination: EmptyView()) {
                            SettingsButtonComp(imageName: "lock.app.dashed", title: "Security")
                            
                        }
                        
                        NavigationLink(destination: EmptyView()) {
                            SettingsButtonComp(imageName: "bell", title: "Notification")
                            
                        }
                        HStack {
                            Text("Other Settings")
                                .padding(.leading,25)
                            Image(systemName: "arrow.down")
                            
                            Spacer()
                        }.padding(.top,10)
                        
                        NavigationLink(destination: EmptyView()) {
                            SettingsButtonComp(imageName: "globe", title: "Language")
                            
                        }
                        
                        NavigationLink(destination: EmptyView()) {
                            SettingsButtonComp(imageName: "icloud.and.arrow.down", title: "Data Migration")
                            
                        }
                        NavigationLink(destination: EmptyView()) {
                            SettingsButtonComp(imageName: "questionmark.app", title: "FAQ")
                            
                        }
                        
                        Button(action: {
                            Task {
                                do {
                                    try viewModel.logOut()
                                    print("loggedout")
                                    isSuccess = true
                                    print(_isSuccess)
                                    print(isSuccess)
                                    
                                    
                                    
                                }
                                catch {
                                    print(error)
                                }
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Log Out")
                                    .font(.system(size: 20))
                                    .padding(.leading,10)
                                Spacer()
                                
                            }.frame(width: UIScreen.main.bounds.width * 7.5 / 10, height: 40)
                                .padding()
                                .padding(.leading, 25)
                                .background(Color("settingsbuttoncolor"), in: .rect(cornerRadius: 25))
                                .padding(.vertical,8)
                        })
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                
            }.navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView(isSuccess: .constant(false))
}

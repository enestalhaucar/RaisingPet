//
//  RootView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 30.07.2024.
//

import SwiftUI

struct RootView: View {
    @State private var isSuccess : Bool = false
    var body: some View {
        ZStack {
            SignInUpBackground()
            if !isSuccess {
                VStack {
                    
                    
                    TabView {
                        HomeView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "house")
                                    Text("Home")
                                }
                            }
                        
                        NoteView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "note.text")
                                    Text("Notes")
                                }
                            }
                        CoupleQuestionView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "person.fill.questionmark")
                                    Text("Couple Questions")
                                }
                            }
                        
                        
                        ProfileView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "person")
                                    Text("Profile")
                                }
                            }
                    }
                }
            }
            
            
        }.onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            print(authUser ?? "auth boş")
            self.isSuccess = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $isSuccess, content: {
            SplashView(isSuccess: $isSuccess)
        })
        
    }
}

#Preview {
    RootView()
}

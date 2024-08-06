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
                                Text("Home")
                            }
                        }
                    CoupleQuestionView()
                        .tabItem {
                            VStack {
                                Image(systemName: "person.fill.questionmark")
                                Text("Couple Questions")
                            }
                        }
                    
                    
                    ProfileView(isSuccess: $isSuccess)
                        .tabItem {
                            VStack {
                                Image(systemName: "person")
                                Text("Profile")
                            }
                        }
                }
            }.fullScreenCover(isPresented: $isSuccess, content: {
                SplashView(isSuccess: $isSuccess)
            })
        }
    }
}

#Preview {
    RootView()
}

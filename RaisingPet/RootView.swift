//
//  RootView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 30.07.2024.
//

import SwiftUI

struct RootView: View {
    @State private var isSuccess : Bool = true
    var body: some View {
        ZStack {
            SignInUpBackground()
            
            VStack {
                TabView {
                    SettingsView(isSuccess: $isSuccess)
                        .tabItem {
                            Image(systemName: "gear")
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

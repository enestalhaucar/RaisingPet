//
//  WallpaperView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 11.05.2025.
//

import SwiftUI

struct WallpaperView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                Text("wallpaper_development_title".localized())
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                Text("wallpaper_development_subtitle".localized())
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 50)
        }
    }
}

#Preview {
    WallpaperView()
}

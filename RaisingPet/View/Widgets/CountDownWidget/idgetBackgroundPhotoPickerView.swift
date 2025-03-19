//
//  idgetBackgroundPhotoPickerView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 2.12.2024.
//

import SwiftUI
import PhotosUI

struct WidgetBackgroundPhotoPickerView: View {
    @Binding var styleIndex: Int
    @Binding var selectedBackgroundPhoto: PhotosPickerItem?
    @Binding var backgroundImage: Image?
    
    var body: some View {
        if styleIndex != 2 { // Stil 3’te fotoğraf kullanılmıyor
            PhotosPicker(selection: $selectedBackgroundPhoto, matching: .images) {
                HStack {
                    Text("Select a background photo")
                    Spacer()
                    Image(systemName: "photo.on.rectangle.angled")
                }
                .padding(.horizontal)
            }
            .onChange(of: selectedBackgroundPhoto) { newValue in
                Task {
                    if let loaded = try? await newValue?.loadTransferable(type: Image.self) {
                        backgroundImage = loaded
                    } else {
                        print("Fotoğraf yüklenemedi")
                    }
                }
            }
        }
    }
}

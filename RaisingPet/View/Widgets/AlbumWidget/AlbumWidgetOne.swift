//
//  AlbumWidgetOne.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 21.10.2024.
//

import SwiftUI

struct AlbumWidgetPreviewDesign: View {
    let item: PetiverseWidgetItem
    
    var body: some View {
        ZStack {
            if let albumImages = item.albumImages, !albumImages.isEmpty,
               let firstImageData = Data(base64Encoded: albumImages[0]),
               let uiImage = UIImage(data: firstImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .clipped()
                    .overlay {
                        if let frameColorStr = item.frameColor,
                           let frameColor = colorFromString(frameColorStr) {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(frameColor, lineWidth: item.lineWidth ?? 5)
                        }
                    }
            } else {
                Color.blue.opacity(0.3)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .overlay {
                        if let frameColorStr = item.frameColor,
                           let frameColor = colorFromString(frameColorStr) {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(frameColor, lineWidth: item.lineWidth ?? 5)
                        }
                    }
            }
        }
        .frame(
            width: item.size == .small ? 170 : item.size == .medium ? 350 : 500,
            height: item.size == .small ? 170 : item.size == .medium ? 170 : 250
        )
    }
    
    private func colorFromString(_ string: String) -> Color? {
        switch string.lowercased() {
        case "black": return .black
        case "blue": return .blue
        case "brown": return .brown
        case "white": return .white
        case "cyan": return .cyan
        case "gray": return .gray
        case "green": return .green
        case "indigo": return .indigo
        case "mint": return .mint
        case "orange": return .orange
        case "pink": return .pink
        case "teal": return .teal
        case "yellow": return .yellow
        default: return nil
        }
    }
}

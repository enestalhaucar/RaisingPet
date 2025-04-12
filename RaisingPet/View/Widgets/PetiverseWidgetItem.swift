//
//  PetiverseWidgetItem.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 19.03.2025.
//


import SwiftUI

// Widget türleri
enum WidgetType: String, Codable {
    case countdown
    case album
    case distance
    case draw
}

// Countdown için tasarım stilleri (1, 2, 3, 4)
enum CountdownStyle: Int, Codable {
    case style1 = 0
    case style2 = 1
    case style3 = 2
    case style4 = 3
}

// Widget boyutu
enum WidgetSize: String, Codable {
    case small
    case medium
    case large
}

// Genel widget modeli

struct PetiverseWidgetItem: Identifiable, Codable {
    let id: UUID
    let type: WidgetType
    let title: String // Album widget için kullanılmayabilir, ama uyumluluk için tutuyoruz
    let backgroundColor: String // Album’da kullanılmayacak, ama varsayılan olarak tutuyoruz
    let textColor: String // Kullanılmayacak
    let backgroundImageData: String? // Countdown’da tek resim, burada liste olacak
    let size: WidgetSize
    let countdownStyle: CountdownStyle?
    let targetDate: Date?
    let albumImages: [String]? // Album widget için Base64 string listesi
    let frameColor: String? // Çerçeve rengi
    let lineWidth: CGFloat? // Çerçeve kalınlığı
    let changeFrequency: String? // Değişim sıklığı
    
    init(
        id: UUID = UUID(),
        type: WidgetType,
        title: String = "",
        backgroundColor: String = "gray",
        textColor: String = "white",
        backgroundImageData: String? = nil,
        size: WidgetSize,
        countdownStyle: CountdownStyle? = nil,
        targetDate: Date? = nil,
        albumImages: [String]? = nil,
        frameColor: String? = nil,
        lineWidth: CGFloat? = nil,
        changeFrequency: String? = nil
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.backgroundImageData = backgroundImageData
        self.size = size
        self.countdownStyle = countdownStyle
        self.targetDate = targetDate
        self.albumImages = albumImages
        self.frameColor = frameColor
        self.lineWidth = lineWidth
        self.changeFrequency = changeFrequency
    }
}

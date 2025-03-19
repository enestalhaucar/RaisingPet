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
    let title: String
    let backgroundColor: String
    let textColor: String
    let backgroundImageData: Data?
    let size: WidgetSize
    let countdownStyle: CountdownStyle?
    let targetDate: Date?
    
    init(
        id: UUID = UUID(),
        type: WidgetType,
        title: String,
        backgroundColor: String,
        textColor: String,
        backgroundImageData: Data? = nil,
        size: WidgetSize,
        countdownStyle: CountdownStyle? = nil,
        targetDate: Date? = nil
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
    }
}

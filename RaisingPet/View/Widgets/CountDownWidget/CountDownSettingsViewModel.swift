//
//  CountDownSettingsViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 2.12.2024.
//
import Foundation
import Combine
import SwiftUI

class CountDownSettingsViewModel: ObservableObject {
    @Published var targetDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 23) // Default 23 days later
    
    // Hesaplanabilir bir property olarak timeRemaining
    var timeRemaining: (days: Int, hours: Int, minutes: Int) {
        let now = Date()
        let diff = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: targetDate)
        return (
            days: diff.day ?? 0,
            hours: diff.hour ?? 0,
            minutes: diff.minute ?? 0
        )
    }
    
    // Listeler
    @Published var itemsOne: [CountDownWidgetOne] = [
        CountDownWidgetOne(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetOne(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    @Published var itemsTwo: [CountDownWidgetTwo] = [
        CountDownWidgetTwo(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetTwo(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    @Published var itemsThree: [CountDownWidgetThree] = [
        CountDownWidgetThree(backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetThree(backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    @Published var itemsFour: [CountDownWidgetFour] = [
        CountDownWidgetFour(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetFour(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
}


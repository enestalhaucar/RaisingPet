//
//  CountDownSettingsViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 2.12.2024.
//
import Foundation
import SwiftUI

class CountDownSettingsViewModel: ObservableObject {
    @Published var targetDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 23) // 23 gün sonrası
    
    var timeRemaining: (days: Int, hours: Int, minutes: Int) {
        let now = Date()
        let diff = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: targetDate)
        return (
            days: max(diff.day ?? 0, 0),
            hours: max(diff.hour ?? 0, 0),
            minutes: max(diff.minute ?? 0, 0)
        )
    }
}


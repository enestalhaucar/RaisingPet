//
//  CountDownWidgetViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 16.10.2024.
//

import Foundation
import SwiftUI

class CountDownWidgetViewModel : ObservableObject {
    @State var timeRemaining: (days: Int, hours: Int, minutes: Int) = (0, 0, 0)
    @State var targetDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 23) // Default 23 days later
    
    @State var itemsOne: [CountDownWidgetOne] = [
        CountDownWidgetOne(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetOne(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    @State var itemsTwo: [CountDownWidgetTwo] = [
        CountDownWidgetTwo(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetTwo(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    @State var itemsThree: [CountDownWidgetThree] = [
        CountDownWidgetThree(backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetThree(backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    @State var itemsFour: [CountDownWidgetFour] = [
        CountDownWidgetFour(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetFour(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    
    func updateRemainingTime() {
        let now = Date()
        let diff = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: targetDate)
        timeRemaining.days = diff.day ?? 0
        timeRemaining.hours = diff.hour ?? 0
        timeRemaining.minutes = diff.minute ?? 0
    }
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // Timer to update every minute
    
}

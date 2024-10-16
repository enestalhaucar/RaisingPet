//
//  CountDownWidget.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 9.10.2024.
//

import Foundation

struct CountDownWidget {
    let targetDate : Date
    let title : String
    var dayRemaining : (days : Int, hour : Int, minutes : Int) {
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: currentDate, to: targetDate)
        return (days: components.day ?? 0, hour: components.hour ?? 0, minutes : components.minute ?? 0)
    }
    
    
}

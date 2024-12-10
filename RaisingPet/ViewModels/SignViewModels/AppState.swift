//
//  AppState.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 10.12.2024.
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet {
            if isLoggedIn {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            } else {
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
            }
        }
    }

    init() {
        // Başlangıç durumu belirle
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}

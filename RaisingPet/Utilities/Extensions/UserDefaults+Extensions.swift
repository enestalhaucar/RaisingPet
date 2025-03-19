//
//  UserDefaults+Extensions.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 19.03.2025.
//

import Foundation


extension UserDefaults {
    private static let hasSeenOnboardingKey = "hasSeenOnboarding"
    
    static var hasSeenOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: hasSeenOnboardingKey) }
        set { UserDefaults.standard.set(newValue, forKey: hasSeenOnboardingKey) }
    }
}

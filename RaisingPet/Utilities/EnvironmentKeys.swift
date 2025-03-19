//
//  EnvironmentKeys.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 20.03.2025.
//

import SwiftUI

private struct BackgroundColorKey: EnvironmentKey {
    static let defaultValue: Color = .blue
}

private struct TextColorKey: EnvironmentKey {
    static let defaultValue: Color = .white
}

extension EnvironmentValues {
    var backgroundColor: Color {
        get { self[BackgroundColorKey.self] }
        set { self[BackgroundColorKey.self] = newValue }
    }
    
    var textColor: Color {
        get { self[TextColorKey.self] }
        set { self[TextColorKey.self] = newValue }
    }
}

//
//  ConstantManager.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 9.06.2025.
//

import Foundation
import UIKit

struct ConstantManager {

    // MARK: - App Configuration
    // Uygulama davranışını test veya production için değiştiren ayarlar.
    struct AppConfig {
        // Test için onboarding - Production da false olmalı, her defasında açılmasını istiyorsan true yap.
        static let showOnboardingEveryTime: Bool = false
    }

    // MARK: - Layout Constants
    // Padding, corner radius, frame boyutları gibi genel UI ölçüleri.
    struct Layout {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height

        static let widthHalf: CGFloat = .init(screenWidth / 2)
        static let widthQuarter: CGFloat = .init(screenWidth / 4)
        static let heightHalf: CGFloat = .init(screenHeight / 2)
        static let widthWithoutEdge: CGFloat = .init(screenWidth - 24)
        static let widthEight: CGFloat = .init(screenWidth * 8 / 10)
        static let widthFour: CGFloat = .init(screenWidth * 4 / 10)
        static let heightFour: CGFloat = .init(screenHeight * 4 / 10)
    }

    // MARK: - Asset Constants
    // Sık kullanılan renk veya resim isimleri. Bu, yazım hatalarını önler.
    struct Assets {
        // Örnek:
        // static let primaryTextColor = Color("PrimaryTextColor")
        // static let eggBackgroundImage = Image("hatchScreenBackgroundImage")
    }
}

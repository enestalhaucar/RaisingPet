//
//  Font+Extensions.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.02.2025.
//

import SwiftUI

/// Nunito font ağırlıkları
enum NunitoFontWeight: String {
    case thin = "Nunito-Thin"
    case extraLight = "Nunito-ExtraLight"
    case light = "Nunito-Light"
    case regular = "Nunito-Regular"
    case medium = "Nunito-Medium"
    case semiBold = "Nunito-SemiBold"
    case bold = "Nunito-Bold"
    case extraBold = "Nunito-ExtraBold"
    case black = "Nunito-Black"
}

/// SwiftUI Typography sistemine uygun boyutlar
enum NunitoTypography: CGFloat {
    case largeTitle34 = 34
    case title28 = 28
    case title222 = 22
    case title320 = 20
    case headline17 = 17
    case subheadline15 = 15
    case body16 = 16
    case callout14 = 14
    case caption12 = 12
    case caption211 = 11
    case footnote13 = 13
}

extension Font {
    /// Nunito Font'u SwiftUI sistemine uygun şekilde çağırır
    static func nunito(_ weight: NunitoFontWeight, _ typography: NunitoTypography, size: CGFloat? = nil) -> Font {
        return .custom(weight.rawValue, size: size ?? typography.rawValue)
    }
}

//
//  Localizable.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.03.2025.
//

import Foundation
import Localize_Swift

enum Languages: String, CaseIterable {
    case tr = "tr"
    case en = "en"

    var stringValue: String {
        switch self {
        case .tr:
            return "lang_turkish".localized()
        case .en:
            return "lang_english".localized()
        }
    }
}

struct Localizable {

    static func allLanguages() -> [Languages] {
        return Languages.allCases
    }

    static var currentLanguage: Languages = getCurrentLanguage()
    static var currentSystemLanguage = Locale.current.language.languageCode ?? "en"
    static var isLanguageChanged = UserDefaults.standard.bool(forKey: "isLanguageChanged")

    static func setCurrentLanguage(_ current: Languages) {
        UserDefaults.standard.setValue(current.rawValue, forKey: LANGUAGE_KEY)
        Localize.setCurrentLanguage(current.rawValue)
        updateCurrentLanguage()
    }

    private static func getCurrentLanguage() -> Languages {
        guard let value = UserDefaults.standard.value(forKey: LANGUAGE_KEY) as? String,
              let language = Languages(rawValue: value) else {
            return .tr
        }
        return language
    }

    private static func updateCurrentLanguage() {
        currentLanguage = getCurrentLanguage()
    }

}

private let LANGUAGE_KEY = "SelectedLanguageKey"

extension String {
    func localized() -> String {
        guard !isEmpty else { return "" }
        let language = Localizable.currentLanguage.rawValue

        guard let localizedPath = Bundle.main.path(forResource: language, ofType: "lproj"),
              let localizedBundle = Bundle(path: localizedPath) else {
            return self
        }
        return localizedBundle.localizedString(forKey: self, value: nil, table: "Localizable")
    }
}

//
//  ValidationUtility.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 12.05.2025.
//

import Foundation

struct ValidationUtility {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }

    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
}

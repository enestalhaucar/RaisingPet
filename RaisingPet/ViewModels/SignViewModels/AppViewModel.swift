//
//  AppViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 16.11.2024.
//

import Foundation


@MainActor
class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        checkIfLoggedIn()
    }
    
    func checkIfLoggedIn() {
        // UserDefaults'ta token varsa kullanıcı giriş yapmış kabul edilir
        if UserDefaults.standard.string(forKey: "userToken") != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
    func logOut() {
        // Çıkış işlemi için token'ı silin
        UserDefaults.standard.removeObject(forKey: "userToken")
        isLoggedIn = false
    }
}


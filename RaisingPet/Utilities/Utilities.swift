//
//  Utilities.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 4.08.2024.
//

import Foundation
import UIKit

final class Utilities {
    static let shared = Utilities()
    private init() {}
    
    @MainActor
    class func topViewController(controller : UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    func getUserDetailsFromUserDefaults() -> [String: String] {
        let firstname = UserDefaults.standard.string(forKey: "userFirstname") ?? "N/A"
        let surname = UserDefaults.standard.string(forKey: "userSurname") ?? "N/A"
        let email = UserDefaults.standard.string(forKey: "userEmail") ?? "N/A"
        let friendTag = UserDefaults.standard.string(forKey: "userFriendTag") ?? "N/A"
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "N/A"
        
        return [
            "firstname": firstname,
            "surname": surname,
            "email": email,
            "friendTag": friendTag,
            "userId": userId
        ]
    }

    
}

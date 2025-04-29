//
//  ShopScreenViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 12.04.2025.
//

import Foundation
import Alamofire


class ShopScreenViewModel : ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var allItems: AllItems?
    
    func fetchAllShopItem() {
        let url = Utilities.Constants.Endpoints.Shop.getAllShopItems
        isLoading = true
        errorMessage = nil
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: GetAllShopItems.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let data):
                        print(data)
                        self.allItems = data.data
                        print(self.allItems as Any)
                        print("allItems")
                        self.isLoading = false
                    case .failure(let error):
                        self.errorMessage = "Hata:1 \(error.localizedDescription)"
                        self.isLoading = false
                    }
                }
            }
    }
    
    func buyItem(itemId: String, mine : MineEnum) {
        let url = Utilities.Constants.Endpoints.Shop.buyItem
        isLoading = true
        errorMessage = nil
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "itemId": itemId,
            "mine" : mine.rawValue
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success:
                        self.isLoading = false
                        print("Item purchased successfully!")
                    case .failure(let error):
                        self.isLoading = false
                        self.errorMessage = "Hata: \(error.localizedDescription)"
                        print("Purchase failed: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    
}

enum MineEnum : String {
    case diamond
    case gold
}

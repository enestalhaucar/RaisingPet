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
    
    func buyShopItem(itemId: String, mine : MineEnum) {
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
    
    func buyPetItem(itemId: String, amount: Int, mine: MineEnum) {
        let url = Utilities.Constants.Endpoints.Pets.buyPetItem
        isLoading = true
        errorMessage = nil
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "petItemId": itemId,
            "amount": amount,
            "mine": mine.rawValue
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let data):
                        self.isLoading = false
                        print("Item purchased successfully: \(data)")
                        // Başarılı satın alma sonrası envanteri güncelle veya kullanıcıya bildirim göster
                    case .failure(let error):
                        self.isLoading = false
                        self.errorMessage = "Hata: \(error.localizedDescription), Detay: \(error)"
                        print("Hata Detayı: \(error), Response: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "Yok")")
                    }
                }
            }
    }
    
    func buyPackageItem(packageType : PackageType, packageId : String, mine : MineEnum? = nil, petItemsWithAmounts : [PetItemWithAmount]? = nil) {
        let url = Utilities.Constants.Endpoints.Package.buyPackageItems
        isLoading = true
        errorMessage = nil
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        
        var parameters: [String: Any] = [
            "packageType": packageType.rawValue,
            "packageId": packageId
        ]
        
        switch packageType {
        case .eggPackage, .petPackage:
            if let m = mine {
                parameters["mine"] = m.rawValue
            }
        case .petItemPackage:
            guard let items = petItemsWithAmounts else {
                self.errorMessage = "Pet-item-package için petItemsWithAmounts gerekli"
                return
            }
            parameters["petItemsWithAmounts"] = items.map {
                ["petItemId": $0.petItemId, "amount": $0.amount]
            }
        }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success:
                        print("Package purchased successfully!")
                    case .failure(let error):
                        self.errorMessage = "Hata: \(error.localizedDescription)"
                        print("Package purchase failed: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    
}

enum MineEnum : String {
    case diamond
    case gold
}

enum PackageType: String {
    case eggPackage
    case petPackage
    case petItemPackage
}

struct PetItemWithAmount: Encodable {
    let petItemId: String
    let amount: Int
}

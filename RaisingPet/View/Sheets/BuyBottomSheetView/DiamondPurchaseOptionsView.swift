//
//  DiamondPurchaseOptionsView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 13.06.2025.
//

import SwiftUI

// MARK: - Diamond Purchase Options
struct DiamondPurchaseOptionsView: View {
    @ObservedObject var vm: ShopScreenViewModel
    @ObservedObject var currentVM: CurrentUserViewModel
    
    // Get available diamond packages for purchase
    private var diamondPackages: [ShopItem] {
        let packages = vm.allItems?.shopItems.filter { $0.category == .gameCurrencyDiamond } ?? []
        return packages.sorted { ($0.price ?? 0) < ($1.price ?? 0) }
    }
    
    // Get 3 diamond packages: cheapest, most expensive, and middle
    private var selectedDiamondPackages: [ShopItem] {
        let packages = diamondPackages
        guard packages.count >= 3 else { return packages }
        
        let cheapest = packages.first!
        let mostExpensive = packages.last!
        let middle = packages[packages.count / 2]
        
        return [mostExpensive, middle, cheapest] // En pahalı, ortanca, en ucuz (soldan sağa)
    }
    
    private func purchaseDiamondPackage(_ diamondItem: ShopItem) {
        Task {
            await vm.buyShopItem(itemId: diamondItem.id!, mine: .diamond) {
                currentVM.refresh()
            }
            // Don't dismiss, let user continue with their original purchase
        }
    }
    
    var body: some View {
        if !selectedDiamondPackages.isEmpty {
            VStack(spacing: 10) {
                Text("bottom_sheet_diamond_purchase_title".localized())
                    .font(.nunito(.semiBold, .body16))
                    .foregroundStyle(.black)
                
                HStack(spacing: 10) {
                    ForEach(selectedDiamondPackages, id: \.id) { diamondItem in
                        VStack(spacing: 8) {
                            Image(diamondItem.name ?? "diamondPlaceholder")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            if let price = diamondItem.price {
                                Text("₺\(price)")
                                    .font(.nunito(.bold, .callout14))
                                    .foregroundStyle(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.yellow.opacity(0.2))
                                .stroke(.yellow.opacity(0.5), lineWidth: 1)
                        )
                        .onTapGesture {
                            purchaseDiamondPackage(diamondItem)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

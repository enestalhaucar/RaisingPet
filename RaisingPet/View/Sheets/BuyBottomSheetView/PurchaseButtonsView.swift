//
//  PurchaseButtonsView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 13.06.2025.
//


import SwiftUI


// MARK: - Purchase Buttons
struct PurchaseButtonsView: View {
    let item: ShopItem
    let counterNumber: Int
    @Binding var selectedMine: MineEnum?
    let userGold: Int
    let userDiamond: Int
    let showCounter: Bool
    @ObservedObject var vm: ShopScreenViewModel
    @ObservedObject var currentVM: CurrentUserViewModel
    let dismiss: DismissAction
    
    private func canAffordItem(with currency: MineEnum) -> Bool {
        let totalGoldPrice = (item.goldPrice ?? 0) * (showCounter ? counterNumber : 1)
        let totalDiamondPrice = (item.diamondPrice ?? 0) * (showCounter ? counterNumber : 1)
        
        switch currency {
        case .gold:
            return userGold >= totalGoldPrice
        case .diamond:
            return userDiamond >= totalDiamondPrice
        }
    }
    
    private func purchaseItem() {
        guard let id = item.id, let mine = selectedMine else { return }

        // 1) Eğer bu bir EggPackage ise:
        if let qty = item.quantity, item.category == .eggs {
            Task {
                await vm.buyPackageItem(
                    packageType: .eggPackage,
                    packageId: id,
                    mine: mine
                ) { currentVM.refresh() }
                dismiss()
            }
            return
        }

        // 2) Eğer petItem ise (home+petItems)
        if item.category == .home && (vm.allItems?.petItems.contains { $0.id == id } ?? false) {
            Task {
                await vm.buyPetItem(itemId: id, amount: counterNumber, mine: mine) {
                    currentVM.refresh()
                }
                dismiss()
            }
            return
        }

        // 3) Aksi hâlde basit shopItem
        Task {
            await vm.buyShopItem(itemId: id, mine: mine) {
                currentVM.refresh()
            }
            dismiss()
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if let diamondPrice = item.diamondPrice, diamondPrice > 0, item.goldPrice == nil || item.goldPrice == 0 {
                // Sadece Diamond Butonu
                BuyPurchaseView(
                    iconName: "diamondIcon",
                    itemName: item.name ?? "-",
                    counterNumber: counterNumber
                ) {
                    selectedMine = .diamond
                    purchaseItem()
                }
                .disabled(!canAffordItem(with: .diamond))
                .opacity(canAffordItem(with: .diamond) ? 1.0 : 0.6)
            } else if let goldPrice = item.goldPrice, goldPrice > 0, item.diamondPrice == nil || item.diamondPrice == 0 {
                // Sadece Gold Butonu
                BuyPurchaseView(
                    iconName: "goldIcon",
                    itemName: item.name ?? "-",
                    counterNumber: counterNumber
                ) {
                    selectedMine = .gold
                    purchaseItem()
                }
                .disabled(!canAffordItem(with: .gold))
                .opacity(canAffordItem(with: .gold) ? 1.0 : 0.6)
            } else if let diamondPrice = item.diamondPrice, let goldPrice = item.goldPrice, diamondPrice > 0, goldPrice > 0 {
                // Hem Diamond hem Gold Butonları
                BuyPurchaseView(
                    iconName: "diamondIcon",
                    itemName: item.name ?? "-",
                    counterNumber: counterNumber
                ) {
                    selectedMine = .diamond
                    purchaseItem()
                }
                .disabled(!canAffordItem(with: .diamond))
                .opacity(canAffordItem(with: .diamond) ? 1.0 : 0.6)
                
                Divider()
                
                BuyPurchaseView(
                    iconName: "goldIcon",
                    itemName: item.name ?? "-",
                    counterNumber: counterNumber
                ) {
                    selectedMine = .gold
                    purchaseItem()
                }
                .disabled(!canAffordItem(with: .gold))
                .opacity(canAffordItem(with: .gold) ? 1.0 : 0.6)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top)
    }
}

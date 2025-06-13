//
//  BuyButtomSheetView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 25.04.2025.
//

import SwiftUI

struct BottomSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var vm: ShopScreenViewModel
    @EnvironmentObject private var currentVM: CurrentUserViewModel
    var item: ShopItem
    @Binding var counterNumber: Int
    @State private var selectedMine: MineEnum?
    @Binding var showCounter: Bool
    @State private var bottomSheetHeight: CGFloat = 0

    var body: some View {
        if item.category == .gameCurrencyDiamond {
            DiamondSheetContentView(
                item: item,
                counterNumber: counterNumber,
                dismiss: dismiss,
                vm: vm,
                currentVM: currentVM
            )
        } else {
            RegularSheetContentView(
                item: item,
                counterNumber: $counterNumber,
                showCounter: $showCounter,
                selectedMine: $selectedMine,
                dismiss: dismiss,
                vm: vm,
                currentVM: currentVM
            )
        }
    }
}

// MARK: - Diamond Sheet Content
struct DiamondSheetContentView: View {
    let item: ShopItem
    let counterNumber: Int
    let dismiss: DismissAction
    @ObservedObject var vm: ShopScreenViewModel
    @ObservedObject var currentVM: CurrentUserViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                SheetHeaderView(dismiss: dismiss)

                ItemInfoView(item: item, showCounter: .constant(false), counterNumber: .constant(counterNumber))

                Button {
                    Task {
                        await vm.buyShopItem(itemId: item.id!, mine: .diamond) {
                            currentVM.refresh()
                        }
                        dismiss()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundStyle(.yellow.opacity(0.3))
                        Text(String(format: "bottom_sheet_buy_diamonds".localized(), item.name?.capitalized ?? "", counterNumber))
                            .font(.nunito(.medium, .callout14))
                    }.padding(.horizontal, 20)
                }
            }
            .background(Color.white)
            .cornerRadius(25)
            .padding(.top, 10)
        }
    }
}

// MARK: - Regular Sheet Content
struct RegularSheetContentView: View {
    let item: ShopItem
    @Binding var counterNumber: Int
    @Binding var showCounter: Bool
    @Binding var selectedMine: MineEnum?
    let dismiss: DismissAction
    @ObservedObject var vm: ShopScreenViewModel
    @ObservedObject var currentVM: CurrentUserViewModel

    // Computed properties for user balances
    private var userGold: Int {
        currentVM.user?.gameCurrencyGold ?? 0
    }

    private var userDiamond: Int {
        currentVM.user?.gameCurrencyDiamond ?? 0
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                SheetHeaderView(dismiss: dismiss)

                ItemInfoView(item: item, showCounter: $showCounter, counterNumber: $counterNumber)

                InsufficientFundsMessageView(
                    item: item,
                    counterNumber: counterNumber,
                    showCounter: showCounter,
                    userGold: userGold,
                    userDiamond: userDiamond,
                    vm: vm,
                    currentVM: currentVM
                )

                PurchaseButtonsView(
                    item: item,
                    counterNumber: counterNumber,
                    selectedMine: $selectedMine,
                    userGold: userGold,
                    userDiamond: userDiamond,
                    showCounter: showCounter,
                    vm: vm,
                    currentVM: currentVM,
                    dismiss: dismiss
                )
            }
            .background(Color.white)
            .cornerRadius(25)
            .padding(.top, 10)
        }
    }
}

// MARK: - Sheet Header
struct SheetHeaderView: View {
    let dismiss: DismissAction

    var body: some View {
        HStack {
            AssetNumberView(iconName: "goldIcon", currencyType: .gold)
            AssetNumberView(iconName: "diamondIcon", currencyType: .diamond)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Item Info View
struct ItemInfoView: View {
    let item: ShopItem
    @Binding var showCounter: Bool
    @Binding var counterNumber: Int

    var body: some View {
        HStack {
            ItemImageView(imageName: item.name ?? "egg")
            if showCounter {
                Spacer()
                BuyCounterView(counterNumber: $counterNumber).minimumScaleFactor(0.8)
            } else {
                DescriptionOfItemView(item: item)
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(RoundedRectangle(cornerRadius: 15).fill(.yellow.opacity(0.05)))
        .padding(.horizontal, 20)
    }
}

// MARK: - Insufficient Funds Message
struct InsufficientFundsMessageView: View {
    let item: ShopItem
    let counterNumber: Int
    let showCounter: Bool
    let userGold: Int
    let userDiamond: Int
    @ObservedObject var vm: ShopScreenViewModel
    @ObservedObject var currentVM: CurrentUserViewModel

    private func getInsufficientFundsMessage() -> String? {
        let totalGoldPrice = (item.goldPrice ?? 0) * (showCounter ? counterNumber : 1)
        let totalDiamondPrice = (item.diamondPrice ?? 0) * (showCounter ? counterNumber : 1)

        // Sadece Gold fiyatı varsa
        if totalGoldPrice > 0 && totalDiamondPrice == 0 {
            if userGold < totalGoldPrice {
                let shortage = totalGoldPrice - userGold
                return String(format: "bottom_sheet_item_purchase".localized(), totalGoldPrice, shortage)
            }
        }
        // Sadece Diamond fiyatı varsa
        else if totalDiamondPrice > 0 && totalGoldPrice == 0 {
            if userDiamond < totalDiamondPrice {
                let shortage = totalDiamondPrice - userDiamond
                return String(format: "bottom_sheet_item_purchase".localized(), totalDiamondPrice, shortage)
            }
        }
        // Hem Gold hem Diamond varsa - herhangi biri ile alınabilir
        else if totalGoldPrice > 0 && totalDiamondPrice > 0 {
            let canAffordWithGold = userGold >= totalGoldPrice
            let canAffordWithDiamond = userDiamond >= totalDiamondPrice

            if !canAffordWithGold && !canAffordWithDiamond {
                // Her ikisi de yeterli değil - daha az eksik olanı göster
                let goldShortage = totalGoldPrice - userGold
                let diamondShortage = totalDiamondPrice - userDiamond

                if goldShortage <= diamondShortage {
                    return String(format: "bottom_sheet_item_purchase".localized(), totalGoldPrice, goldShortage)
                } else {
                    return String(format: "bottom_sheet_item_purchase".localized(), totalDiamondPrice, diamondShortage)
                }
            }
        }

        return nil
    }

    var body: some View {
        if let insufficientMessage = getInsufficientFundsMessage() {
            VStack(spacing: 15) {
                Text(insufficientMessage)
                    .font(.nunito(.medium, .callout14))
                    .foregroundStyle(.red)
                    .padding(.horizontal, 20)

                DiamondPurchaseOptionsView(vm: vm, currentVM: currentVM)
            }
        }
    }
}

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

// MARK: - Supporting Views
struct ItemImageView: View {
    var imageName: String
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .frame(width: 100, height: 100)
        }
    }
}

struct BuyCounterView: View {
    @Binding var counterNumber: Int
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        if counterNumber > 1 {
                            counterNumber -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .opacity(counterNumber == 1 ? 0.3 : 1)
                    }

                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 90, height: 25)
                            .foregroundColor(.yellow.opacity(0.4))

                        Text("\(counterNumber)")
                            .font(.nunito(.medium, .callout14))
                    }
                    Spacer()
                    Button {
                        if counterNumber < 10 {
                            counterNumber += 1
                        }
                    } label: {
                        Image(systemName: "plus")
                            .opacity(counterNumber == 10 ? 0.3 : 1)
                    }
                }.padding(.horizontal)
                HStack {
                    CounterItemBackgroundView(counterNumber: 3) { counterNumber = 3}
                    Spacer()
                    CounterItemBackgroundView(counterNumber: 5) { counterNumber = 5 }
                    Spacer()
                    CounterItemBackgroundView(counterNumber: 10, badgeVisible: true, onTap: { counterNumber = 10})
                }
            }.frame(width: ConstantManager.Layout.widthHalf)
        }
    }
}

struct CounterItemBackgroundView: View {
    var counterNumber: Int
    var badgeVisible: Bool = false
    var onTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 60, height: 25)
                .foregroundColor(.yellow.opacity(0.4))
            Text("\(counterNumber)")
                .font(.nunito(.medium, .callout14))

            if badgeVisible {
                HStack {
                    Spacer()
                    Text("bottom_sheet_badge_plus_one".localized())
                        .font(.nunito(.thin, .caption211))
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Circle().fill(Color.red))
                        .frame(width: 20, height: 20)
                        .offset(x: 10, y: -10)
                }
                .padding(5)
            }
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct DescriptionOfItemView: View {
    var item: ShopItem
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(item.name ?? " - ")")
                .font(.nunito(.semiBold, .body16))
            Text("\(item.description ?? " - ")")
                .font(.nunito(.medium, .callout14))
                .foregroundStyle(.gray.opacity(0.3))
        }
    }
}

struct BuyPurchaseView: View {
    var iconName: String
    var itemName: String
    var counterNumber: Int
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.yellow.opacity(0.3))
                HStack {
                    Image(iconName)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(String(format: "bottom_sheet_get_item".localized(), itemName.capitalized, counterNumber))
                        .font(.nunito(.medium, .callout14))
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

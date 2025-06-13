//
//  BuyPackageCounterPopUpView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 29.04.2025.
//

import SwiftUI

// MARK: - PetItemType Extension for Unique Key
extension PetItemType {
    /// Provides a unique key for identification in ForEach
    var uniqueKey: String { id ?? _id ?? UUID().uuidString }
}

// MARK: - BuyPackageCounterPopUpView

struct BuyPackageCounterPopUpView: View {
    let petItems: [PetItemType]
    let limit: Int
    @Binding var isPresented: Bool
    let isAdPackage: Bool
    var onApply: ([PetItemWithAmount]) -> Void

    @State private var counts: [String: Int]
    @EnvironmentObject var interstitialManager: InterstitialAdsManager
    @State private var isShowingAd = false

    private var totalSelected: Int { counts.values.reduce(0, +) }
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(
        petItems: [PetItemType],
        limit: Int,
        isPresented: Binding<Bool>,
        isAdPackage: Bool,
        onApply: @escaping ([PetItemWithAmount]) -> Void
    ) {
        self.petItems = petItems
        self.limit = limit
        self._isPresented = isPresented
        self.isAdPackage = isAdPackage
        self.onApply = onApply

        var initial: [String: Int] = [:]
        petItems.forEach { initial[$0.uniqueKey] = 0 }
        self._counts = State(initialValue: initial)
    }

    var body: some View {
        VStack(spacing: 16) {
            // — X kapatma butonu
            HStack {
                Spacer()
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            // — Başlık
            Text(String(format: "buy_package_select_items".localized(), limit))
                .font(.nunito(.bold, .body16))

            // — Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(petItems, id: \.uniqueKey) { item in
                        let key = item.uniqueKey
                        PackageItemCellView(
                            item: item,
                            count: counts[key] ?? 0,
                            canIncrement: totalSelected < limit,
                            canDecrement: (counts[key] ?? 0) > 0,
                            onIncrement: { counts[key, default: 0] += 1 },
                            onDecrement: { counts[key, default: 0] -= 1 }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.6)

            // — Uygula Butonu
            Button(action: {
                let selections = counts.compactMap { id, amt in
                    amt > 0 ? PetItemWithAmount(petItemId: id, amount: amt) : nil
                }

                if isAdPackage {
                    // Reklam paketi ise, reklam göster
                    isShowingAd = true
                    interstitialManager.displayInterstitialAd {
                        isShowingAd = false // Reklam kapandı
                        onApply(selections) // Ürünleri ver
                        isPresented = false // Pop-up'ı kapat
                    }
                } else {
                    // Normal paket ise, direkt ürünleri ver
                    onApply(selections)
                    isPresented = false
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(totalSelected == limit
                              ? Color.yellow.opacity(0.3)    // etkin hali
                              : Color.gray.opacity(0.3))     // devre dışı hali
                        .frame(height: 50)

                    Text(isAdPackage ? "buy_package_get_with_ad_button".localized() : "buy_package_get_button".localized())
                        .font(.nunito(.medium, .callout14))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
            }
            .disabled(totalSelected != limit)
            .padding(.horizontal, 20)

            // Reklam yüklenirken gösterilecek overlay
            if isShowingAd {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                    Text("Reklam Yükleniyor...")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.top, 20)
                }
            }
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - PackageItemCellView

struct PackageItemCellView: View {
    let item: PetItemType
    let count: Int
    let canIncrement: Bool
    let canDecrement: Bool
    let onIncrement: () -> Void
    let onDecrement: () -> Void

    var body: some View {
        ZStack {
            // Arka plan
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.05))

            VStack(spacing: 12) {
                // Ürün görseli
                Image(item.name ?? "placeholderItemNamePhoto")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)

                // İsim
                Text(item.name ?? "buy_package_default_item".localized())
                    .font(.subheadline)
                    .multilineTextAlignment(.center)

                // Alttaki artı-eksi kontrol grubu
                HStack(spacing: 20) {
                    Button(action: onDecrement) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                    }
                    .disabled(!canDecrement)

                    Text("\(count)")
                        .font(.nunito(.bold, .callout14))
                        .frame(minWidth: 24)

                    Button(action: onIncrement) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .disabled(!canIncrement)
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.yellow.opacity(0.2))
                )
            }
            .padding(12)
        }
        // Sabit yükseklik & genişlik
        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
    }
}
